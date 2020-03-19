import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:syktsu_schedule/core/entities/version.dart';

import '../core/entities/event.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/repositories/schedule_repository.dart';
import '../utils.dart';

import 'services/schedule_local_data_source.dart';
import 'services/schedule_remote_data_source.dart';
import 'services/network_info.dart';

class SyktsuScheduleRepository extends ScheduleRepository {
  final ScheduleLocalDataSource local;
  final ScheduleRemoteDataSource remote;
  final NetworkInfo network;

  SyktsuScheduleRepository(
      {@required this.local, @required this.remote, @required this.network});

  @override
  Future<Either<Failure, List<Version>>> fetchScheduleVersions(
      ScheduleParams params) async {
    try {
      final List<Version> localVersions =
          await local.fetchScheduleVersions(params);
      if (await network.isConnected) {
        final remoteVersion = await remote.fetchScheduleVersion(params);
        final uniqVersions = uniqItems<Version>(localVersions, [remoteVersion]);
        if (uniqVersions.length > 0) {
          final savedVersion =
              await local.saveScheduleVersion(params, remoteVersion);
          return Right([...localVersions, savedVersion]);
        }
      }
      return Right(localVersions);
    } on ServerException {
      return Left(ServerFailure());
    } on LocalException {
      return Left(LocalFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> fetchScheduleEvents(
      Schedule schedule, int versionIndex, int weekIndex) async {
    try {
      if (await network.isConnected) {
        final remoteVersion =
            await remote.fetchScheduleVersion(schedule.params);
        if (schedule.versions[versionIndex] == remoteVersion) {
          final remoteEvents =
              await remote.fetchScheduleEvents(schedule, weekIndex);
          if (remoteEvents.length > 0) {
            final localEvents = await local.fetchScheduleEvents(
                schedule, versionIndex, weekIndex);
            if (remoteEvents.length != localEvents.length) {
              final savedEvents = await local.saveScheduleEvents(
                  schedule, versionIndex, weekIndex, remoteEvents);
              return Right(savedEvents);
            }
            return Right(localEvents);
          }
        }
      }
      final localEvents =
          await local.fetchScheduleEvents(schedule, versionIndex, weekIndex);
      return Right(localEvents);
    } on ServerException {
      return Left(ServerFailure());
    } on LocalException {
      return Left(LocalFailure());
    }
  }
}

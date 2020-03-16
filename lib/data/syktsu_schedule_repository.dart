import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:syktsu_schedule/core/entities/version.dart';

import '../core/entities/event.dart';
import '../core/entities/schedule.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/repositories/schedule_repository.dart';

import 'services/schedule_local_data_source.dart';
import 'services/schedule_remote_data_source.dart';

class SyktsuScheduleRepository extends ScheduleRepository {
  final ScheduleLocalDataSource local;
  final ScheduleRemoteDataSource remote;

  SyktsuScheduleRepository({@required this.local, @required this.remote});

  @override
  Stream<Either<Failure, List<Version>>> fetchScheduleVersions(
      Schedule schedule) async* {
    try {
      final localVersions = await local.fetchScheduleVersions(schedule.params);
      yield Right(localVersions);
      final remoteVersion = await remote.fetchScheduleVersion(schedule.params);
      if (localVersions.firstWhere(
              (version) =>
                  version.dateTime.compareTo(remoteVersion.dateTime) == 0,
              orElse: () => null) ==
          null) {
        final savedVersion =
            await local.saveScheduleVersion(schedule, remoteVersion);
        yield Right([...localVersions, savedVersion]);
      }
    } on ServerException {
      yield Left(ServerFailure());
    } on LocalException {
      yield Left(LocalFailure());
    }
  }

  @override
  Stream<Either<Failure, List<Event>>> fetchScheduleEvents(
      Schedule schedule, int versionIndex, int weekIndex) async* {
    try {
      final localEvents =
          await local.fetchScheduleEvents(schedule, versionIndex, weekIndex);
      if (localEvents.length > 0) {
        yield Right(localEvents);
      } else {
        final remoteVersion =
            await remote.fetchScheduleVersion(schedule.params);
        if (schedule.versions[versionIndex].dateTime
                .compareTo(remoteVersion.dateTime) ==
            0) {
          final remoteEvents =
              await remote.fetchScheduleEvents(schedule, weekIndex);
          if (remoteEvents.length > 0) {
            final savedEvents = await local.saveScheduleEvents(
                schedule, versionIndex, weekIndex, remoteEvents);
            yield Right(savedEvents);
          }
        } else {
          throw NotAvailableVersionException();
        }
      }
    } on ServerException {
      yield Left(ServerFailure());
    } on LocalException {
      yield Left(LocalFailure());
    } on NotAvailableVersionException {
      yield Left(NotAvailableVersionFailure());
    }
  }
}

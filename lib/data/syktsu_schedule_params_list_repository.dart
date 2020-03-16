import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/repositories/schedule_params_list_repository.dart';
import '../core/utils.dart';

import 'services/schedule_params_list_local_data_source.dart';
import 'services/schedule_params_list_remote_data_source.dart';

class SyktsuScheduleParamsListRepository
    implements ScheduleParamsListRepository {
  final ScheduleParamsListLocalDataSource local;
  final ScheduleParamsListRemoteDataSource remote;

  SyktsuScheduleParamsListRepository(
      {@required this.local, @required this.remote});

  Future<Schedule> _fetchSchedule(ScheduleParams params) async {
    final localSchedule = await local.fetchSchedule(params);
    if (localSchedule != null) {
      return localSchedule;
    }
    final remoteSchedule = await remote.fetchSchedule(params);
    return local.saveSchedule(remoteSchedule);
  }

  @override
  Stream<Either<Failure, ObjectsUnion<List<ScheduleParams>, Schedule>>>
      fetchScheduleParamsListOrSchedule(
          ScheduleType type, String searchPhrase) async* {
    try {
      final localParamsList =
          await local.fetchScheduleParamsList(type, searchPhrase);
      yield Right(ObjectsUnion(localParamsList));
      final remotePramsList =
          await remote.fetchScheduleParamsListOrSchedule(type, searchPhrase);
      if (remotePramsList.isRight()) {
        yield Right(remotePramsList);
      } else {
        await local.saveScheduleParamsList(remotePramsList.left);
        final mergedParamsList =
            await local.fetchScheduleParamsList(type, searchPhrase);
        if (mergedParamsList.length == 1) {
          final schedule = await _fetchSchedule(mergedParamsList.first);
          yield Right(ObjectsUnion(schedule));
        } else {
          yield Right(ObjectsUnion(mergedParamsList));
        }
      }
    } on LocalException {
      yield Left(LocalFailure());
    } on ServerException {
      yield Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Schedule>> fetchSchedule(ScheduleParams params) async {
    try {
      final schedule = await _fetchSchedule(params);
      return Right(schedule);
    } on LocalException {
      return Left(LocalFailure());
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

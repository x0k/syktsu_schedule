import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/repositories/schedule_params_list_repository.dart';
import '../core/utils.dart';
import '../utils.dart';

import 'services/schedule_params_list_local_data_source.dart';
import 'services/schedule_params_list_remote_data_source.dart';
import 'services/network_info.dart';

class SyktsuScheduleParamsListRepository
    implements ScheduleParamsListRepository {
  final ScheduleParamsListLocalDataSource local;
  final ScheduleParamsListRemoteDataSource remote;
  final NetworkInfo network;

  SyktsuScheduleParamsListRepository(
      {@required this.local, @required this.remote, @required this.network});

  @override
  Future<Either<Failure, List<ScheduleParams>>> fetchLocalScheduleParamsList(
      ScheduleType type, String searchPhrase) async {
    try {
      final paramsList =
          await local.fetchScheduleParamsList(type, searchPhrase);
      return Right(paramsList);
    } on LocalException {
      return Left(LocalFailure());
    }
  }

  Future<Schedule> _fetchSchedule(ScheduleParams params) async {
    if (await network.isConnected) {
      final remoteSchedule = await remote.fetchSchedule(params);
      return local.saveSchedule(remoteSchedule);
    }
    return local.fetchSchedule(params);
  }

  @override
  Future<Either<Failure, ObjectsUnion<List<ScheduleParams>, Schedule>>>
      fetchRemoteScheduleParamsListOrSchedule(
          ScheduleType type, String searchPhrase) async {
    try {
      if (await network.isConnected) {
        final remotePramsListOrSchedule =
            await remote.fetchScheduleParamsListOrSchedule(type, searchPhrase);
        if (remotePramsListOrSchedule.isRight()) {
          final schedule =
              await local.saveSchedule(remotePramsListOrSchedule.right);
          return Right(ObjectsUnion(schedule));
        } else {
          final remotePramsList = remotePramsListOrSchedule.left;
          final localParamsList =
              await local.fetchScheduleParamsList(type, searchPhrase);
          return Right(ObjectsUnion(localParamsList.length <
                  remotePramsList.length
              ? localParamsList +
                  await local.saveScheduleParamsList(uniqItems<ScheduleParams>(
                      localParamsList,
                      remotePramsList,
                      (local, remote) => local.id == remote.id))
              : localParamsList));
        }
      }
      final localParamsList =
          await local.fetchScheduleParamsList(type, searchPhrase);
      if (localParamsList.length == 1) {
        final schedule = await _fetchSchedule(localParamsList.first);
        return Right(ObjectsUnion(schedule));
      }
      return Right(ObjectsUnion(localParamsList));
    } on LocalException {
      return Left(LocalFailure());
    } on ServerException {
      return Left(ServerFailure());
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

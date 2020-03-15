import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/repositories/schedules_repository.dart';
import '../core/utils.dart';

import 'sources/schedule_params_list_remote_data_source.dart';

class SyktsuScheduleParamsListRepository
    implements ScheduleParamsListRepository {
  final ScheduleParamsListRemoteDataSource remoteDataSource;

  SyktsuScheduleParamsListRepository({@required this.remoteDataSource});

  @override
  Future<Either<Failure, ObjectUnion<EntityCollection<ScheduleParams>, Schedule>>> fetchScheduleParamsListOrSchedule(
      ScheduleType type, String searchPhrase) async {
    try {
      final result =
          await remoteDataSource.fetchScheduleParamsListOrSchedule(type, searchPhrase);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

}

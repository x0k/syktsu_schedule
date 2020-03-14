import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/entities/schedule_params_list.dart';
import '../core/repositories/schedules_repository.dart';

import 'sources/schedule_params_list_remote_data_source.dart';

class SyktsuScheduleParamsListRepository
    implements ScheduleParamsListRepository {
  final ScheduleParamsListRemoteDataSource remoteDataSource;

  SyktsuScheduleParamsListRepository({@required this.remoteDataSource});

  @override
  Future<Either<Failure, ScheduleParamsList>> fetchScheduleParamsList(
      ScheduleType type, String searchPhrase) async {
    try {
      final result =
          await remoteDataSource.fetchScheduleParamsList(type, searchPhrase);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

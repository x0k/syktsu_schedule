import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/entities/event.dart';
import '../core/entities/schedule.dart';
import '../core/entities/schedule_params.dart';
import '../core/errors/failures.dart';
import '../core/errors/exceptions.dart';
import '../core/repositories/schedule_repository.dart';
import '../core/utils.dart';

import 'sources/schedule_remote_data_source.dart';

class SyktsuScheduleRepository extends ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  SyktsuScheduleRepository({@required this.remoteDataSource});

  static Future<Either<Failure, T>> _makeRequest<T>(
      Future<T> future) async {
    try {
      final result = await future;
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Schedule>> fetchSchedule(ScheduleParams params) {
    return _makeRequest(remoteDataSource.fetchSchedule(params));
  }

  @override
  Future<Either<Failure, EntityCollection<Event>>> fetchScheduleEvents(
      ScheduleType type, String weekId) {
    return _makeRequest(remoteDataSource.fetchScheduleEvents(type, weekId));
  }
}

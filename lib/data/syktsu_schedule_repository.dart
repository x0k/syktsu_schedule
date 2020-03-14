import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/errors/failures.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/entities/event.dart';
import '../core/repositories/schedule_repository.dart';

import 'sources/schedule_remote_data_source.dart';

class SyktsuScheduleRepository extends ScheduleRepository {
  final ScheduleRemoteDataSource remoteDataSource;

  SyktsuScheduleRepository({@required this.remoteDataSource});

  @override
  Future<Either<Failure, Schedule>> fetchSchedule(ScheduleParams params) async {
    try {
      final result = await remoteDataSource.fetchSchedule(params);
      return Right(result);
    } on Exception {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Event>>> fetchScheduleEvents(
      ScheduleType type, String weekId) {
    // TODO: implement fetchScheduleEvents
    throw UnimplementedError();
  }
}

import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../entities/schedule_params.dart';
import '../entities/event.dart';
import '../entities/schedule.dart';
import '../entities/version.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, List<Version>>> fetchScheduleVersions(ScheduleParams params);
  Future<Either<Failure, List<Event>>> fetchScheduleEvents(Schedule schedule, int versionIndex, int weekIndex);
}
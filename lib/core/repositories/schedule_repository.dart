import 'package:dartz/dartz.dart';

import '../errors/failures.dart';
import '../entities/event.dart';
import '../entities/schedule.dart';
import '../entities/version.dart';

abstract class ScheduleRepository {
  Stream<Either<Failure, List<Version>>> fetchScheduleVersions(Schedule schedule);
  Stream<Either<Failure, List<Event>>> fetchScheduleEvents(Schedule schedule, int versionIndex, int weekIndex);
}
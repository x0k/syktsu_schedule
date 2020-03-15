import 'package:dartz/dartz.dart';

import '../constants.dart';
import '../entities/schedule.dart';
import '../entities/schedule_params.dart';
import '../errors/failures.dart';
import '../entities/event.dart';
import '../utils.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, Schedule>> fetchSchedule(ScheduleParams params);
  Future<Either<Failure, EntityCollection<Event>>> fetchScheduleEvents(ScheduleType type, String weekId);
}
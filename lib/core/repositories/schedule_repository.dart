import 'package:dartz/dartz.dart';

import '../constants.dart';
import '../errors/failures.dart';
import '../entities/schedule.dart';
import '../entities/schedule_params.dart';
import '../entities/event_list.dart';

abstract class ScheduleRepository {
  Future<Either<Failure, Schedule>> fetchSchedule(ScheduleParams params);
  Future<Either<Failure, EventList>> fetchScheduleEvents(ScheduleType type, String weekId);
}
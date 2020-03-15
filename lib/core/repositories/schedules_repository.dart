import 'package:dartz/dartz.dart';

import '../constants.dart';
import '../entities/schedule_params.dart';
import '../entities/schedule.dart';
import '../errors/failures.dart';
import '../utils.dart';

abstract class ScheduleParamsListRepository {
  Future<Either<Failure, ObjectUnion<EntityCollection<ScheduleParams>, Schedule>>> fetchScheduleParamsListOrSchedule(ScheduleType type, String searchPhrase);
}

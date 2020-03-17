import 'package:dartz/dartz.dart';

import '../constants.dart';
import '../entities/schedule_params.dart';
import '../entities/schedule.dart';
import '../errors/failures.dart';
import '../utils.dart';

abstract class ScheduleParamsListRepository {
  Future<Either<Failure, List<ScheduleParams>>> fetchLocalScheduleParamsList(ScheduleType type, String searchPhrase);
  Future<Either<Failure, ObjectsUnion<List<ScheduleParams>, Schedule>>> fetchRemoteScheduleParamsListOrSchedule(ScheduleType type, String searchPhrase);
  Future<Either<Failure, Schedule>> fetchSchedule(ScheduleParams params);
}

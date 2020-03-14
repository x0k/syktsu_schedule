import 'package:dartz/dartz.dart';

import '../constants.dart';
import '../entities/schedule_params_list.dart';
import '../errors/failures.dart';

abstract class ScheduleParamsListRepository {
  Future<Either<Failure, ScheduleParamsList>> fetchScheduleParamsList(ScheduleType type, String searchPhrase);
}

import '../../core/constants.dart';
import '../../core/entities/schedule.dart';
import '../../core/entities/schedule_params.dart';
import '../../core/utils.dart';

abstract class ScheduleParamsListRemoteDataSource {
  Future<ObjectsUnion<List<ScheduleParams>, Schedule>>
      fetchScheduleParamsListOrSchedule(ScheduleType type, String searchPhrase);
  Future<Schedule> fetchSchedule(ScheduleParams params);
}

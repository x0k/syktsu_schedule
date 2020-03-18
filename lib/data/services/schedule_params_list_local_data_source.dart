import '../../core/constants.dart';
import '../../core/entities/schedule.dart';
import '../../core/entities/schedule_params.dart';

abstract class ScheduleParamsListLocalDataSource {
  Future<List<ScheduleParams>> fetchScheduleParamsList(
      ScheduleType type, String searchPhrase);
  Future<Schedule> fetchSchedule(ScheduleParams params);
  Future<Schedule> saveSchedule(Schedule schedule);
}

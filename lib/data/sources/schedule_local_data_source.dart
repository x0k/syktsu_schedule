import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';
import '../../models/schedule.dart';
import '../../models/event_list_model.dart';

abstract class ScheduleLocalDataSource {
  Future<ScheduleModel> fetchSchedule(ScheduleParams params);
  Future<EventListModel> fetchScheduleEvents(ScheduleType type, String weekId);
}
import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';
import '../../models/schedule_model.dart';
import '../../models/event_list_model.dart';

abstract class ScheduleRemoteDataSource {
  Future<ScheduleModel> fetchSchedule(ScheduleParams params);
  Future<EventListModel> fetchScheduleEvents(ScheduleType type, String weekId);
}
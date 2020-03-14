import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';

abstract class SchedulesEvent {
  const SchedulesEvent();
}

class GetSchedules extends SchedulesEvent {
  final String searchPhrase;
  final ScheduleType type;

  GetSchedules({ this.type, this.searchPhrase });
}

class SelectSchedule extends SchedulesEvent {
  final ScheduleParams params;

  SelectSchedule(this.params);
}

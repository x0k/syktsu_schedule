import 'package:syktsu_schedule/data/schedule_params.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class GetSchedule extends ScheduleEvent {
  final ScheduleParams params;
  GetSchedule(this.params);
}

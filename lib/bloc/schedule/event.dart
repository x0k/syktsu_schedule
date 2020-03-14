import 'package:meta/meta.dart';

import '../../core/entities/schedule.dart';
import '../../core/entities/schedule_params.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class GetSchedule extends ScheduleEvent {
  final ScheduleParams params;
  const GetSchedule({@required this.params});
}

class LoadWeek extends ScheduleEvent {
  final Schedule schedule;
  final List<dynamic> events;
  final int week;
  const LoadWeek(
      {@required this.schedule, @required this.events, @required this.week});
}

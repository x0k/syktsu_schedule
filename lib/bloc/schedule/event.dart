import 'package:meta/meta.dart';

import '../../core/entities/schedule.dart';
import '../../core/entities/schedule_params.dart';
import '../../core/entities/list_items.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class LoadSchedule extends ScheduleEvent {
  final ScheduleParams params;
  const LoadSchedule({@required this.params});
}

class LoadInitialWeek extends ScheduleEvent {
  final Schedule schedule;
  final int version;
  const LoadInitialWeek({@required this.schedule, @required this.version});
}

class LoadWeek extends ScheduleEvent {
  final Schedule schedule;
  final List<ListItem> items;
  final int week;
  final int version;
  const LoadWeek(
      {@required this.schedule,
      @required this.items,
      @required this.week,
      @required this.version});
}

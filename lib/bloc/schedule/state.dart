import 'package:meta/meta.dart';

import '../../core/entities/schedule.dart';
import '../../core/entities/list_items.dart';

abstract class ScheduleState {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleLoaded extends ScheduleState {
  final Schedule schedule;
  final List<ListItem> items;
  final int week;
  final int version;
  final bool loading;
  const ScheduleLoaded(
      {@required this.schedule,
      @required this.items,
      @required this.version,
      @required this.week,
      @required this.loading});
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError({@required this.message});
}

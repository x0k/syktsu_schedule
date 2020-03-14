import 'package:meta/meta.dart';

import '../../core/entities/schedule.dart';

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
  const ScheduleLoaded({@required this.schedule});
}

class ScheduleEvents extends ScheduleState {
  final Schedule schedule;
  final List<dynamic> events;
  final int week;
  final bool loading;
  const ScheduleEvents(
      {@required this.schedule,
      @required this.events,
      @required this.week,
      @required this.loading});
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError({@required this.message});
}

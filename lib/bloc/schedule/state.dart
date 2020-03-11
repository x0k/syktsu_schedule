import 'package:syktsu_schedule/data/model/schedule.dart';
import 'package:syktsu_schedule/data/model/week.dart';
// import 'package:syktsu_schedule/data/model/event.dart';

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
  final List<Week> weeks;
  const ScheduleLoaded(this.schedule, this.weeks);
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError(this.message);
}

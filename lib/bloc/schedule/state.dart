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
  const ScheduleLoaded(this.schedule);
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError(this.message);
}

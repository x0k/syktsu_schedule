import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../core/repositories/schedule_repository.dart';

import 'event.dart';
import 'state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc(this.repository);

  @override
  ScheduleState get initialState => ScheduleInitial();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is GetSchedule) {
      yield ScheduleLoading();
      final data = await repository.fetchSchedule(event.params);
      yield data.isRight()
          ? ScheduleLoaded(schedule: data.getOrElse(null))
          : ScheduleError(message: "Couldn't fetch schedule.");
    } else if (event is LoadWeek) {
      yield ScheduleEvents(
        schedule: event.schedule,
        events: event.events,
        loading: true,
        week: event.week,
      );
      final schedule = event.schedule;
      final data = await repository.fetchScheduleEvents(
          schedule.type, schedule.weeks[event.week].id);
      yield data.isRight()
          ? ScheduleEvents(
              schedule: schedule,
              events: [
                ...event.events,
                schedule.weeks[event.week],
                ...data.getOrElse(null).list
              ],
              loading: false,
              week: event.week)
          : ScheduleError(message: "Couldn't fetch schedule events.");
    }
  }
}

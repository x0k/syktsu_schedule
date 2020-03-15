import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../core/entities/schedule.dart';
import '../../core/repositories/schedule_repository.dart';
import '../../core/services/list_items_maker.dart';
import '../../core/entities/list_items.dart';

import 'event.dart';
import 'state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;
  final ItemsMaker maker;

  ScheduleBloc(this.repository, this.maker);

  Stream<ScheduleState> _loadWeek(
      {List<ListItem> items, Schedule schedule, int weekIndex}) async* {
    yield ScheduleLoaded(
      schedule: schedule,
      items: items,
      loading: true,
      week: weekIndex,
    );
    final week = schedule.weeks[weekIndex];
    final data = await repository.fetchScheduleEvents(schedule.type, week.id);
    yield data.isRight()
        ? ScheduleLoaded(
            schedule: schedule,
            items: [...items, ...maker.makeItems(week, data.getOrElse(null))],
            loading: false,
            week: weekIndex)
        : ScheduleError(message: "Couldn't fetch schedule events.");
  }

  Stream<ScheduleState> _loadInitialWeek(Schedule schedule) async* {
    final now = DateTime.now();
    final week =
        schedule.weeks.lastIndexWhere((week) => week.startTime.isBefore(now));
    yield* _loadWeek(items: [], schedule: schedule, weekIndex: week);
  }

  @override
  ScheduleState get initialState => ScheduleInitial();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is LoadWeek) {
      yield* _loadWeek(
          items: event.items, schedule: event.schedule, weekIndex: event.week);
    } else if (event is LoadInitialWeek) {
      yield* _loadInitialWeek(event.schedule);
    } else if (event is LoadSchedule) {
      yield ScheduleLoading();
      final data = await repository.fetchSchedule(event.params);
      if (data.isRight()) {
        final schedule = data.getOrElse(null);
        yield* _loadInitialWeek(schedule);
      } else {
        yield ScheduleError(
            message: "Couldn't fetch schedule ${event.params.title}");
      }
    }
  }
}

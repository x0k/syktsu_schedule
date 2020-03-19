import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../core/entities/schedule.dart';
import '../../core/entities/list_items.dart';
import '../../core/repositories/schedule_repository.dart';
import '../../core/repositories/schedule_params_list_repository.dart';

import '../services/list_items_maker.dart';

import 'event.dart';
import 'state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository scheduleRepository;
  final ScheduleParamsListRepository paramsListRepository;
  final ItemsMaker maker;

  ScheduleBloc(this.scheduleRepository, this.paramsListRepository, this.maker);

  Stream<ScheduleState> _loadWeek(List<ListItem> items, Schedule schedule,
      int weekIndex, int versionIndex) async* {
    yield ScheduleLoaded(
      schedule: schedule,
      version: versionIndex,
      items: items,
      loading: true,
      week: weekIndex,
    );
    final data = await scheduleRepository.fetchScheduleEvents(
        schedule, versionIndex, weekIndex);
    yield data.isRight()
        ? ScheduleLoaded(
            schedule: schedule,
            items: [
              ...items,
              ...maker.makeItems(
                  schedule.weeks[weekIndex], data.getOrElse(null))
            ],
            loading: false,
            week: weekIndex,
            version: versionIndex)
        : ScheduleError(message: "Couldn't fetch schedule events.");
  }

  Stream<ScheduleState> _loadInitialWeek(Schedule schedule, int version,
      [DateTime dateTime]) async* {
    final now = dateTime ?? DateTime.now();
    final week = schedule.weeks
        .lastIndexWhere((week) => week.startDateTime.isBefore(now));
    yield* _loadWeek([], schedule, week > -1 ? week : 0, version);
  }

  @override
  ScheduleState get initialState => ScheduleInitial();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    if (event is LoadWeek) {
      yield* _loadWeek(event.items, event.schedule, event.week, event.version);
    } else if (event is LoadInitialWeek) {
      yield* _loadInitialWeek(event.schedule, event.version, event.dateTime);
    } else if (event is LoadSchedule) {
      yield ScheduleLoading();
      final data = await paramsListRepository.fetchSchedule(event.params);
      if (data.isRight()) {
        final schedule = data.getOrElse(null);
        yield* _loadInitialWeek(schedule, schedule.versions.length - 1);
      } else {
        yield ScheduleError(
            message: "Couldn't fetch schedule ${event.params.title}");
      }
    }
  }
}

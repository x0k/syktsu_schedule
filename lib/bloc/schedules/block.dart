import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../core/entities/schedule_params.dart';
import '../../core/repositories/schedules_repository.dart';
import '../../core/utils.dart';

import 'event.dart';
import 'state.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  final ScheduleParamsListRepository repository;

  SchedulesBloc(this.repository);

  @override
  SchedulesState get initialState => SchedulesInitial();

  @override
  Stream<SchedulesState> mapEventToState(SchedulesEvent event) async* {
    if (event is LoadSchedule) {
      yield SchedulesSelectedParams(
          type: event.type,
          params: event.paramsList[event.selected],
          paramsList: event.paramsList,
          searchPhrase: event.searchPhrase);
    } else if (event is GetSchedules) {
      yield SchedulesLoading();
      final data = await repository.fetchScheduleParamsListOrSchedule(
          event.type, event.searchPhrase);
      if (data.isRight()) {
        final item = data.getOrElse(null);
        yield item.isRight()
            ? SchedulesSelectedSchedule(
                type: item.right.type,
                schedule: item.right,
                searchPhrase: event.searchPhrase,
                paramsList: EntityCollection([]))
            : SchedulesLoaded(
                type: event.type,
                searchPhrase: event.searchPhrase,
                paramsList: item.left);
      } else {
        SchedulesError("Couldn't fetch schedules.");
      }
    }
  }
}

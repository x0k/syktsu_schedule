import 'dart:async';
import 'package:bloc/bloc.dart';

import '../../core/repositories/schedules_repository.dart';

import 'event.dart';
import 'state.dart';

class SchedulesBloc extends Bloc<SchedulesEvent, SchedulesState> {
  final ScheduleParamsListRepository repository;

  SchedulesBloc(this.repository);

  @override
  SchedulesState get initialState => SchedulesInitial();

  @override
  Stream<SchedulesState> mapEventToState(SchedulesEvent event) async* {
    if (event is SelectSchedule) {
      yield SchedulesSelected(event.params);
    } else {
      yield SchedulesLoading();
      if (event is GetSchedules) {
        final data = await repository.fetchScheduleParamsList(
            event.type, event.searchPhrase);
        yield data.isRight()
            ? SchedulesLoaded(
                type: event.type,
                searchPhrase: event.searchPhrase,
                paramsList: data.getOrElse(null))
            : SchedulesError("Couldn't fetch schedules.");
      }
    }
  }
}

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:syktsu_schedule/data/schedule_repository.dart';

import 'event.dart';
import 'state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final ScheduleRepository repository;

  ScheduleBloc(this.repository);

  @override
  ScheduleState get initialState => ScheduleInitial();

  @override
  Stream<ScheduleState> mapEventToState(ScheduleEvent event) async* {
    yield ScheduleLoading();
    if (event is GetSchedule) {
      try {
        final data = await repository.fetchSchedule(event.params);
        yield ScheduleLoaded(data.first, data.second);
      } on Error {
        yield ScheduleError("Couldn't fetch groups.");
      }
    }
  }

}
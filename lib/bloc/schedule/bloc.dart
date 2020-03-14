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
    yield ScheduleLoading();
    if (event is GetSchedule) {
      final data = await repository.fetchSchedule(event.params);
      yield data.isRight()
          ? ScheduleLoaded(data.getOrElse(null))
          : ScheduleError("Couldn't fetch schedule.");
    }
  }
}

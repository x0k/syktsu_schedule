import 'dart:async';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:syktsu_schedule/core/constants.dart';

import '../../core/repositories/schedule_params_list_repository.dart';

import 'event.dart';
import 'state.dart';

class SchedulesBloc extends HydratedBloc<SchedulesEvent, SchedulesState> {
  final ScheduleParamsListRepository repository;

  SchedulesBloc(this.repository);

  @override
  SchedulesState get initialState =>
      super.initialState ??
      SchedulesInitial(searchPhrase: '', type: ScheduleType.group);

  @override
  Stream<SchedulesState> mapEventToState(SchedulesEvent event) async* {
    if (event is LoadSchedule) {
      yield SchedulesSelectedParams(
          type: event.type,
          params: event.paramsList[event.selected],
          paramsList: event.paramsList,
          searchPhrase: event.searchPhrase);
    } else if (event is GetLocalScheduleParamsList) {
      final data = await repository.fetchLocalScheduleParamsList(
          event.type, event.searchPhrase);
      if (data.isRight()) {
        final item = data.getOrElse(null);
        yield SchedulesLoaded(
            type: event.type,
            searchPhrase: event.searchPhrase,
            paramsList: item);
      } else {
        SchedulesError("Couldn't fetch schedules.");
      }
    } else if (event is GetRemoteScheduleParamsList) {
      yield SchedulesLoading(
          searchPhrase: event.searchPhrase, type: event.type);
      final data = await repository.fetchRemoteScheduleParamsListOrSchedule(
          event.type, event.searchPhrase);
      if (data.isRight()) {
        final item = data.getOrElse(null);
        yield item.isRight()
            ? SchedulesSelectedSchedule(
                type: item.right.params.type,
                schedule: item.right,
                searchPhrase: event.searchPhrase,
                paramsList: [])
            : SchedulesLoaded(
                type: event.type,
                searchPhrase: event.searchPhrase,
                paramsList: item.left);
      } else {
        SchedulesError("Couldn't fetch schedules.");
      }
    }
  }

  @override
  SchedulesState fromJson(Map<String, dynamic> source) {
    if (source != null) {
      return SchedulesLoaded.fromJSON(source);
    }
    return null;
  }

  @override
  Map<String, dynamic> toJson(SchedulesState state) {
    if (state.runtimeType == SchedulesLoaded) {
      return SchedulesLoaded.toJSON(state);
    }
    return null;
  }
}

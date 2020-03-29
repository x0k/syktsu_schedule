import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../core/entities/schedule.dart';
import '../../core/entities/schedule_params.dart';

abstract class SchedulesState {
  const SchedulesState();
}

class SchedulesInitial extends SchedulesState {
  final String searchPhrase;
  final ScheduleType type;
  const SchedulesInitial({@required this.searchPhrase, @required this.type});
}

class SchedulesLoading extends SchedulesInitial {
  const SchedulesLoading(
      {@required ScheduleType type, @required String searchPhrase})
      : super(type: type, searchPhrase: searchPhrase);
}

class SchedulesLoaded extends SchedulesInitial {
  static SchedulesLoaded fromJSON(Map<String, dynamic> data) {
    return SchedulesLoaded(
        paramsList: data['paramsList']
            .map((item) => ScheduleParams.fromJSON(item))
            .toList()
            .cast<ScheduleParams>(),
        type: scheduleNameTypes[data['type']],
        searchPhrase: data['searchPhrase']);
  }

  static Map<String, dynamic> toJSON(SchedulesLoaded state) {
    return {
      'paramsList':
          state.paramsList.map((item) => ScheduleParams.toJSON(item)).toList(),
      'type': scheduleTypeNames[state.type],
      'searchPhrase': state.searchPhrase,
    };
  }

  final List<ScheduleParams> paramsList;

  const SchedulesLoaded(
      {@required ScheduleType type,
      @required String searchPhrase,
      @required this.paramsList})
      : super(type: type, searchPhrase: searchPhrase);
}

class SchedulesSelectedParams extends SchedulesLoaded {
  final ScheduleParams params;
  const SchedulesSelectedParams(
      {@required this.params,
      @required ScheduleType type,
      @required String searchPhrase,
      @required List<ScheduleParams> paramsList})
      : super(type: type, searchPhrase: searchPhrase, paramsList: paramsList);
}

class SchedulesSelectedSchedule extends SchedulesLoaded {
  final Schedule schedule;
  const SchedulesSelectedSchedule(
      {@required this.schedule,
      @required ScheduleType type,
      @required String searchPhrase,
      @required List<ScheduleParams> paramsList})
      : super(type: type, searchPhrase: searchPhrase, paramsList: paramsList);
}

class SchedulesError extends SchedulesState {
  final String message;
  const SchedulesError(this.message);
}

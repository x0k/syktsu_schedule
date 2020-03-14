import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../core/entities/schedule_params_list.dart';

abstract class SchedulesEvent {
  const SchedulesEvent();
}

class GetSchedules extends SchedulesEvent {
  final String searchPhrase;
  final ScheduleType type;

  const GetSchedules({ @required this.type, @required this.searchPhrase });
}

class SelectSchedule extends SchedulesEvent {
  final int selected;
  final String searchPhrase;
  final ScheduleType type;
  final ScheduleParamsList paramsList;

  const SelectSchedule(
      {@required this.selected,
      @required ScheduleType this.type,
      @required String this.searchPhrase,
      @required ScheduleParamsList this.paramsList});
}

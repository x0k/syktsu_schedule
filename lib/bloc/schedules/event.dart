import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';
import '../../core/utils.dart';

abstract class SchedulesEvent {
  const SchedulesEvent();
}

class GetSchedules extends SchedulesEvent {
  final String searchPhrase;
  final ScheduleType type;
  const GetSchedules({@required this.type, @required this.searchPhrase});
}

class LoadSchedule extends SchedulesEvent {
  final int selected;
  final String searchPhrase;
  final ScheduleType type;
  final EntityCollection<ScheduleParams> paramsList;
  const LoadSchedule(
      {@required this.selected,
      @required this.type,
      @required this.searchPhrase,
      @required this.paramsList});
}

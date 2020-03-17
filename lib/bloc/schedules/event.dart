import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';

abstract class SchedulesEvent {
  const SchedulesEvent();
}

class ScheduleParamsFetch extends SchedulesEvent {
  final ScheduleType type;
  final String searchPhrase;
  const ScheduleParamsFetch({@required this.type, @required this.searchPhrase});
}

class GetLocalScheduleParamsList extends ScheduleParamsFetch {
  const GetLocalScheduleParamsList(
      {@required ScheduleType type, @required String searchPhrase})
      : super(type: type, searchPhrase: searchPhrase);
}

class GetRemoteScheduleParamsList extends ScheduleParamsFetch {
  const GetRemoteScheduleParamsList(
      {@required ScheduleType type, @required String searchPhrase})
      : super(type: type, searchPhrase: searchPhrase);
}

class LoadSchedule extends SchedulesEvent {
  final int selected;
  final String searchPhrase;
  final ScheduleType type;
  final List<ScheduleParams> paramsList;
  const LoadSchedule(
      {@required this.selected,
      @required this.type,
      @required this.searchPhrase,
      @required this.paramsList});
}

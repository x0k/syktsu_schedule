import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';
import '../../core/entities/schedule_params_list.dart';

abstract class SchedulesState {
  const SchedulesState();
}

class SchedulesInitial extends SchedulesState {
  const SchedulesInitial();
}

class SchedulesLoading extends SchedulesState {
  const SchedulesLoading();
}

class SchedulesLoaded extends SchedulesState {
  final String searchPhrase;
  final ScheduleType type;
  final ScheduleParamsList paramsList;

  const SchedulesLoaded(
      {@required this.type,
      @required this.searchPhrase,
      @required this.paramsList});
}

class SchedulesSelected extends SchedulesLoaded {
  final int selected;
  const SchedulesSelected(
      {@required this.selected,
      @required ScheduleType type,
      @required String searchPhrase,
      @required ScheduleParamsList paramsList})
      : super(type: type, searchPhrase: searchPhrase, paramsList: paramsList);
}

class SchedulesError extends SchedulesState {
  final String message;
  const SchedulesError(this.message);
}

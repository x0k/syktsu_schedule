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

  const SchedulesLoaded({this.type, this.searchPhrase, this.paramsList});
}

class SchedulesSelected extends SchedulesState {
  final ScheduleParams params;
  SchedulesSelected(this.params);
}

class SchedulesError extends SchedulesState {
  final String message;
  const SchedulesError(this.message);
}

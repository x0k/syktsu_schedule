import 'package:meta/meta.dart';

import '../../core/constants.dart';
import '../../core/entities/schedule.dart';
import '../../core/entities/schedule_params.dart';
import '../../core/utils.dart';

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
  final EntityCollection<ScheduleParams> paramsList;

  const SchedulesLoaded(
      {@required this.type,
      @required this.searchPhrase,
      @required this.paramsList});
}

class SchedulesSelectedParams extends SchedulesLoaded {
  final ScheduleParams params;
  const SchedulesSelectedParams(
      {@required this.params,
      @required ScheduleType type,
      @required String searchPhrase,
      @required EntityCollection<ScheduleParams> paramsList})
      : super(type: type, searchPhrase: searchPhrase, paramsList: paramsList);
}

class SchedulesSelectedSchedule extends SchedulesLoaded {
  final Schedule schedule;
  const SchedulesSelectedSchedule(
      {@required this.schedule,
      @required ScheduleType type,
      @required String searchPhrase,
      @required EntityCollection<ScheduleParams> paramsList})
      : super(type: type, searchPhrase: searchPhrase, paramsList: paramsList);
}

class SchedulesError extends SchedulesState {
  final String message;
  const SchedulesError(this.message);
}

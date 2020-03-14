import 'package:meta/meta.dart';

import '../../core/entities/schedule_params.dart';

abstract class ScheduleEvent {
  const ScheduleEvent();
}

class GetSchedule extends ScheduleEvent {
  final ScheduleParams params;
  GetSchedule({ @required this.params});
}

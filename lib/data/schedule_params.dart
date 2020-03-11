import 'enums/schedule_type.dart';

class ScheduleParams {
  final String id;
  final ScheduleType type;
  ScheduleParams(this.type, this.id);
}
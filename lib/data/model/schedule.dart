import 'package:syktsu_schedule/data/enums/schedule_type.dart';

class Schedule {
  String id;
  ScheduleType type;
  DateTime updateTime;

  Schedule(this.id, this.type, this.updateTime);
}
import 'package:meta/meta.dart';

import '../constants.dart';

import './week.dart';

class Schedule {
  String id;
  ScheduleType type;
  DateTime updateTime;
  List<Week> weeks;

  Schedule(
      {@required this.id,
      @required this.type,
      @required this.updateTime,
      @required this.weeks});
}

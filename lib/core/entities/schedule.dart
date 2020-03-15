import 'package:meta/meta.dart';

import '../constants.dart';

import 'schedule_params.dart';
import 'week.dart';

class Schedule extends ScheduleParams {

  final DateTime updateTime;
  final List<Week> weeks;

  const Schedule(
      {@required String id,
      @required ScheduleType type,
      @required String title,
      @required this.updateTime,
      @required this.weeks})
      : super(id: id, type: type, title: title);

  String get updateTimeString => dateTimeFormat.format(updateTime);
}

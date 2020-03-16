import 'package:meta/meta.dart';

import 'schedule_params.dart';
import 'version.dart';
import 'week.dart';

class Schedule {
  final ScheduleParams params;
  final List<Version> versions;
  final List<Week> weeks;

  const Schedule(
      {@required this.params, @required this.versions, @required this.weeks});
}

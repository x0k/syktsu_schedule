import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'schedule_params.dart';
import 'version.dart';
import 'week.dart';

class Schedule extends Equatable {
  final ScheduleParams params;
  final List<Version> versions;
  final List<Week> weeks;

  const Schedule(
      {@required this.params, @required this.versions, @required this.weeks});

  DateTime get startDateTime => weeks.first.startDateTime;
  DateTime get endDateTime => weeks.last.startDateTime.add(Duration(days: 7));

  @override
  List<Object> get props => [params, versions, weeks];
}

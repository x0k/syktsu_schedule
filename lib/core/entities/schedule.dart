import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'schedule_params.dart';
import 'version.dart';
import 'week.dart';

class Schedule extends Equatable {
  static Schedule fromJSON(Map<String, dynamic> data) {
    return Schedule(
        params: ScheduleParams.fromJSON(data['params']),
        weeks: data['weeks'].map((week) => Week.fromJSON(week)),
        versions:
            data['versions'].map((version) => Version.fromJSON(version)));
  }

  static Map<String, dynamic> toJSON(Schedule schedule) {
    return {
      'params': ScheduleParams.toJSON(schedule.params),
      'weeks': schedule.weeks.map((week) => Week.toJSON(week)).toList(),
      'versions': schedule.versions
          .map((version) => Version.toJSON(version))
          .toList()
    };
  }

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

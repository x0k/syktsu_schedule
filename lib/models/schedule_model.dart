import '../core/entities/schedule.dart';

import 'schedule_params_model.dart';
import 'week_model.dart';
import 'version_model.dart';

class ScheduleModel {
  static Schedule fromJSON(Map<String, dynamic> data) {
    return Schedule(
        params: ScheduleParamsModel.fromJSON(data['params']),
        weeks: data['weeks'].map((week) => WeekModel.fromJSON(week)),
        versions:
            data['versions'].map((version) => VersionModel.fromJSON(version)));
  }

  static Map<String, dynamic> toJSON(Schedule schedule) {
    return {
      'params': ScheduleParamsModel.toJSON(schedule.params),
      'weeks': schedule.weeks.map((week) => WeekModel.toJSON(week)).toList(),
      'versions': schedule.versions
          .map((version) => VersionModel.toJSON(version))
          .toList()
    };
  }
}

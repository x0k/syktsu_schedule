import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../db_config.dart';

class ScheduleParamsModel {
  static ScheduleParams fromJSON(Map<String, dynamic> data) {
    return ScheduleParams(
        id: data[ParamsTable.id].toString(),
        type: scheduleNameTypes[data[ParamsTable.type]],
        title: data[ParamsTable.title]);
  }

  static Map<String, dynamic> toJSON(ScheduleParams params) {
    return {
      ParamsTable.id: params.id,
      ParamsTable.type: scheduleTypeNames[params.type],
      ParamsTable.title: params.title
    };
  }
}

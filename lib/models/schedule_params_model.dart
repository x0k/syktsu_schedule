import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../db_config.dart';

class ScheduleParamsModel extends ScheduleParams {
  ScheduleParamsModel({
    @required String id,
    @required ScheduleType type,
    @required String title,
  }) : super(id: id, type: type, title: title);

  factory ScheduleParamsModel.fromJSON(Map<String, dynamic> data) {
    return ScheduleParamsModel(
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

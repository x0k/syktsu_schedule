import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../constants.dart';

class ScheduleParams extends Equatable {
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

  final String id;
  final ScheduleType type;
  final String title;
  const ScheduleParams(
      {@required this.id, @required this.type, @required this.title});

  @override
  List<Object> get props => [id];
}

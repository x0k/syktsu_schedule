import 'package:meta/meta.dart';

import '../core/entities/week.dart';
import '../db_config.dart';

class WeekModel extends Week {
  WeekModel(
      {@required String id,
      @required String title,
      @required DateTime startDateTime})
      : super(id: id, title: title, startDateTime: startDateTime);

  factory WeekModel.fromJSON(Map<String, dynamic> data) {
    return WeekModel(
        id: data[WeekTable.id],
        title: data[WeekTable.title],
        startDateTime:
            DateTime.fromMillisecondsSinceEpoch(data[WeekTable.startDateTime]));
  }

  static Map<String, dynamic> toJSON(Week week) {
    return {
      WeekTable.id: week.id,
      WeekTable.title: week.title,
      WeekTable.startDateTime: week.startDateTime.millisecondsSinceEpoch
    };
  }
}

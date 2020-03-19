import '../core/entities/week.dart';
import '../core/entities/date_time.dart';
import '../db_config.dart';

class WeekModel {
  static Week fromJSON(Map<String, dynamic> data) {
    return Week(
        id: data[WeekTable.id],
        title: data[WeekTable.title],
        startDateTime: EquatableDateTime.fromMillisecondsSinceEpoch(
            data[WeekTable.startDateTime]));
  }

  static Map<String, dynamic> toJSON(Week week) {
    return {
      WeekTable.id: week.id,
      WeekTable.title: week.title,
      WeekTable.startDateTime: week.startDateTime.millisecondsSinceEpoch
    };
  }
}

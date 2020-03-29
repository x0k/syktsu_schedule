import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

class Day {
  static final dayNameFormat = DateFormat('dd.MM.yyyy EEEE');

  static Day fromJSON(Map<String, dynamic> data) {
    return Day(
        number: data['number'],
        weekStartTime:
            DateTime.fromMillisecondsSinceEpoch(data['weekStartTime']));
  }

  static Map<String, dynamic> toJSON(Day day) {
    return {
      'number': day.number,
      'weekStartTime': day.weekStartTime.millisecondsSinceEpoch,
    };
  }

  final int number;
  final DateTime weekStartTime;
  const Day({@required this.number, @required this.weekStartTime});
  DateTime get date => weekStartTime.add(Duration(days: number - 1));
  String get name => dayNameFormat.format(date);
}

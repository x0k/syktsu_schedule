import 'package:intl/intl.dart';
class Day {
  static final dayNameFormat = DateFormat('dd.MM.yyyy EEEE');

  final int number;
  final DateTime weekStartTime;
  const Day(this.number, this.weekStartTime);
  DateTime get date => weekStartTime.add(Duration(days: number - 1));
  String get name => dayNameFormat.format(date);
}

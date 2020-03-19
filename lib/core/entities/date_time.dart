import 'package:equatable/equatable.dart';

class EquatableDateTime extends DateTime with EquatableMixin {
  static EquatableDateTime now() {
    return EquatableDateTime.formDateTime(DateTime.now());
  }

  EquatableDateTime(
    int year, [
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  ]) : super(year, month, day, hour, minute, second, millisecond, microsecond);

  factory EquatableDateTime.formDateTime(DateTime dateTime) {
    return EquatableDateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        dateTime.hour,
        dateTime.minute,
        dateTime.second,
        dateTime.millisecond,
        dateTime.microsecond);
  }

  factory EquatableDateTime.fromMillisecondsSinceEpoch(
      int millisecondsSinceEpoch) {
    final dateTime =
        DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    return EquatableDateTime.formDateTime(dateTime);
  }

  @override
  List<Object> get props {
    return [year, month, day, hour, minute, second, millisecond, microsecond];
  }
}

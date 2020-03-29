import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../constants.dart';

import 'date_time.dart';

class Week extends Equatable {
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

  final String id;
  final String title;
  final EquatableDateTime startDateTime;

  Week({@required this.id, @required this.title, @required this.startDateTime});

  @override
  List<Object> get props => [id];
}

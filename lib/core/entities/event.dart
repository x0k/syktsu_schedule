import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../constants.dart';

class Event extends Equatable {
  static Event fromJSON(Map<String, dynamic> data) {
    return Event(
        id: data[EventTable.id],
        day: data[EventTable.day],
        number: data[EventTable.number],
        place: data[EventTable.place],
        subGroup: data[EventTable.subGroup] != null
            ? data[EventTable.subGroup].toString()
            : null,
        subject: data[EventTable.subject],
        teacher: data[EventTable.teacher]);
  }

  static Map<String, dynamic> toJSON(Event event) {
    return {
      EventTable.id: event.id,
      EventTable.day: event.day,
      EventTable.number: event.number,
      EventTable.place: event.place,
      EventTable.subGroup: event.subGroup,
      EventTable.subject: event.subject,
      EventTable.teacher: event.teacher,
    };
  }

  final int id;
  final int day;
  final int number;
  final String subject;
  final String teacher;
  final String place;
  final String subGroup;

  Event(
      {@required this.id,
      @required this.day,
      @required this.number,
      @required this.teacher,
      @required this.subject,
      @required this.place,
      @required this.subGroup});

  String get numberName => numberNames[number];

  @override
  List<Object> get props => [day, number, subject, teacher, place, subGroup];
}

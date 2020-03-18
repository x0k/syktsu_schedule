import 'package:meta/meta.dart';

import '../core/entities/event.dart';
import '../db_config.dart';

class EventModel extends Event {
  EventModel({
    int id,
    @required int day,
    @required int number,
    @required String subject,
    @required String teacher,
    @required String place,
    @required String subGroup,
  }) : super(
            id: id,
            day: day,
            number: number,
            subject: subject,
            teacher: teacher,
            place: place,
            subGroup: subGroup);

  factory EventModel.fromJSON(Map<String, dynamic> data) {
    return EventModel(
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
}

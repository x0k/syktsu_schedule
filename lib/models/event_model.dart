import '../core/entities/event.dart';
import '../db_config.dart';

class EventModel {
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
}

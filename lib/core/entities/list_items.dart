import 'event.dart';
import 'day.dart';

abstract class ListItem<T> {

  static ListItem fromJSON(Map<String, dynamic> data) {
    return data['type'] == 'day'
        ? DayListItem(Day.fromJSON(data['data']))
        : EventListItem(Event.fromJSON(data['data']));
  }

  static Map<String, dynamic> toJSON(ListItem item) {
    final isDay = item is DayListItem;
    return {
      'type': isDay ? 'day' : 'event',
      'data': isDay ? Day.toJSON(item.data) : Event.toJSON(item.data)
    };
  }

  final T data;
  const ListItem(this.data);
}

class DayListItem extends ListItem<Day> {
  const DayListItem(Day data) : super(data);
}

class EventListItem extends ListItem<Event> {
  const EventListItem(Event data) : super(data);
}


import 'event.dart';
import 'day.dart';

abstract class ListItem<T> {
  final T data;
  const ListItem(this.data);
}

class DayListItem extends ListItem<Day> {
  const DayListItem(Day data) : super(data);
}

class EventListItem extends ListItem<Event> {
  const EventListItem(Event data) : super(data);
}

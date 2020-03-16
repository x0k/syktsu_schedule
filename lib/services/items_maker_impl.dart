import '../core/entities/day.dart';
import '../core/entities/week.dart';
import '../core/entities/event.dart';
import '../core/entities/list_items.dart';
import '../bloc/services/list_items_maker.dart';

class EventsKeeper {
  final int day;
  final Iterable<ListItem> items;
  const EventsKeeper(this.day, this.items);
}

class ItemsMakerImpl extends ItemsMaker {
  static Iterable<ListItem> _makeEvents(DateTime start, List<Event> events) {
    return events.fold(
        EventsKeeper(events[0].day, [DayListItem(Day(events[0].day, start))]),
        (EventsKeeper keeper, event) {
      return EventsKeeper(event.day, [
        ...keeper.items,
        if (keeper.day != event.day) DayListItem(Day(event.day, start)),
        EventListItem(event)
      ]);
    }).items;
  }

  @override
  List<ListItem> makeItems(Week week, List<Event> events) {
    return [if (events.length > 0) ..._makeEvents(week.startDateTime, events)];
  }
}

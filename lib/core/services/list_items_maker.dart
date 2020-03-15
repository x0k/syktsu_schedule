import '../entities/list_items.dart';
import '../entities/week.dart';
import '../entities/event.dart';
import '../utils.dart';

abstract class ItemsMaker {
  List<ListItem> makeItems(Week week, EntityCollection<Event> events);
}
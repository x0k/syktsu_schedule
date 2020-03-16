import '../../core/entities/list_items.dart';
import '../../core/entities/week.dart';
import '../../core/entities/event.dart';

abstract class ItemsMaker {
  List<ListItem> makeItems(Week week, List<Event> events);
}

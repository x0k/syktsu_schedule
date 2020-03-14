import 'package:html/dom.dart' show Document, Element;

import '../core/entities/event.dart';
import '../core/entities/event_list.dart';

class RowsKeeper {
  final int day;
  final List<Event> rows;
  RowsKeeper({this.day, this.rows});
}

class EventListModel extends EventList {
  static const _rowsSelector = 'table.schedule > tbody > tr';

  static const _dayCellClass = 'dayofweek';

  static const _subGroupSelector = 'b';

  static Iterable<Event> _makeEvents(int day, List<Element> cells) {
    final int number = int.parse(cells[0].text);
    final subjects = cells.skip(2);
    return subjects.where((subject) => subject.text.length > 0).map((subject) {
      final lines = subject.text
          .split('\n')
          .map((line) => line.replaceAll('\t', '').trim())
          .toList();
      final teacherAndPlaceText = lines[1].split(', ');
      return Event(
        day: day,
        number: number,
        subject: lines[0],
        teacher: teacherAndPlaceText[0],
        place: teacherAndPlaceText[1],
        subGroup: lines[2].length > 0 ? lines[2] : null,
      );
    });
  }

  factory EventListModel.fromDocument(Document document) {
    final keeper = document
        .querySelectorAll(_rowsSelector)
        .skip(1)
        .fold(RowsKeeper(day: 0, rows: []), (RowsKeeper acc, Element row) {
      final day = acc.day + 1;
      final rows = [
        ...acc.rows,
        ..._makeEvents(
            day,
            row.children[0].classes.contains(_dayCellClass)
                ? row.children.skip(1).toList()
                : row.children)
      ];
      return RowsKeeper(day: day, rows: rows);
    });
    return EventListModel(list: keeper.rows);
  }

  EventListModel({List<Event> list}) : super(list: list);

  Map<String, dynamic> _eventToJSON(Event event) {
    return {
      'day': event.day,
      'number': event.number,
      'subject': event.subject,
      'teacher': event.teacher,
      'place': event.place,
      'subGroup': event.subGroup,
    };
  }

  Map<String, dynamic> toJSON() {
    return {'list': list.map((event) => _eventToJSON(event)).toList()};
  }
}

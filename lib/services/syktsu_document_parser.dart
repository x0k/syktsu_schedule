import 'package:html/dom.dart';
import 'package:intl/intl.dart';

import '../core/constants.dart';
import '../core/entities/week.dart';
import '../core/entities/version.dart';
import '../core/entities/event.dart';
import '../core/entities/schedule_params.dart';
import '../data_sources/services/document_parser.dart';

class RowsKeeper {
  final int day;
  final List<Event> rows;
  RowsKeeper({this.day, this.rows});
}

class SyktsuDocumentParser extends DocumentParser {
  static const _scheduleTitleSelector = 'h3[style]';
  static const _scheduleUpdateTextSelector = 'center > i';
  static const _scheduleWeekSelector = 'select[name=\'weeks\'] > option';
  static const _scheduleRowsSelector = 'table.schedule > tbody > tr';
  static const _scheduleDayCellClass = 'dayofweek';
  static const _scheduleParamsSelectors = const {
    ScheduleType.group: 'button[name=\'group\']',
    ScheduleType.teacher: 'button[name=\'name\']',
    ScheduleType.classroom: 'button[name=\'aud\']'
  };
  static const _scheduleTitlePatterns = const [
    'для группы ',
    'для аудитории ',
    'для преподавателя '
  ];

  static List<String> _toLines(String text) {
    return text
        .split('\n')
        .map((line) => line.replaceAll('\t', '').trim())
        .toList();
  }

  static Iterable<Event> _makeEvents(int day, Iterable<Element> cells) {
    final int number = int.parse(cells.first.text);
    final subjects = cells.skip(2);
    return subjects.where((subject) => subject.text.length > 0).map((subject) {
      final lines = _toLines(subject.text);
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

  static DateTime _parseDate(String text, RegExp pattern, DateFormat parser) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      return parser.parse(match.group(1));
    }
    return DateTime.now();
  }

  @override
  bool hasSchedule(Document document) {
    return document.querySelector(_scheduleTitleSelector) != null;
  }

  @override
  String extractScheduleTitle(Document document) {
    final header = document.querySelector(_scheduleTitleSelector);
    final titleLine = _toLines(header.text)[2];
    return _scheduleTitlePatterns.fold(
        titleLine, (value, pattern) => value.replaceAll(pattern, ''));
  }

  @override
  List<Event> extractEvents(Document document) {
    final keeper = document
        .querySelectorAll(_scheduleRowsSelector)
        .skip(1)
        .fold(RowsKeeper(day: 0, rows: []), (RowsKeeper acc, Element row) {
      final isDayCell = row.children[0].classes.contains(_scheduleDayCellClass);
      final day = acc.day + (isDayCell ? 1 : 0);
      final rows = [
        ...acc.rows,
        ..._makeEvents(day, isDayCell ? row.children.skip(1) : row.children)
      ];
      return RowsKeeper(day: day, rows: rows);
    });
    return keeper.rows;
  }

  @override
  Version extractVersion(Document document) {
    final element = document.querySelector(_scheduleUpdateTextSelector);
    return Version(
        dateTime: element != null
            ? _parseDate(element.text, dateTimeExtractor, dateTimeFormat)
            : DateTime.now());
  }

  @override
  List<Week> extractWeeks(Document document) {
    return document
        .querySelectorAll(_scheduleWeekSelector)
        .skip(1)
        .map((item) => Week(
            id: item.attributes['value'],
            title: item.text,
            startDateTime: _parseDate(item.text, dateExtractor, dateFormat)))
        .toList();
  }

  @override
  List<ScheduleParams> extractSchedulePramsList(
      ScheduleType type, Document document) {
    return document
        .querySelectorAll(_scheduleParamsSelectors[type])
        .map((item) => ScheduleParams(
            id: item.attributes['value'], title: item.text, type: type))
        .toList();
  }
}

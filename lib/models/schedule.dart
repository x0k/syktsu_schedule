import 'package:intl/intl.dart';
import 'package:html/dom.dart' show Document;

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/entities/week.dart';

class ScheduleModel extends Schedule {
  static final _dateFormat = DateFormat('dd.MM.yyyy');
  static final _dateExtractor = RegExp(r"(\d{2}\.\d{2}.\d{4})");

  static const _updateTextSelector = 'center > i';
  static const _weeksSelector =
      'select[name=\'weeks\'] > option:not([disabled="disabled"])';

  static DateTime _extractDate(String text) {
    final match = _dateExtractor.firstMatch(text);
    if (match != null) {
      return _dateFormat.parse(match.group(1));
    }
    return DateTime.now();
  }

  static DateTime _extractUpdateTime(Document document) {
    final element = document.querySelector(_updateTextSelector);
    if (element != null) {
      return _extractDate(element.text);
    }
    return DateTime.now();
  }

  static List<Week> _extractWeeks(Document document) {
    return document
        .querySelectorAll(_weeksSelector)
        .map((item) => Week(
            id: item.attributes['value'],
            title: item.text,
            startTime: _extractDate(item.text)))
        .toList();
  }

  factory ScheduleModel.fromDocument(ScheduleParams params, Document document) {
    return ScheduleModel(
        id: params.id,
        type: params.type,
        updateTime: _extractUpdateTime(document),
        weeks: _extractWeeks(document));
  }

  ScheduleModel(
      {String id, ScheduleType type, DateTime updateTime, List<Week> weeks})
      : super(id: id, type: type, updateTime: updateTime, weeks: weeks);
}

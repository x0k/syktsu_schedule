import 'package:intl/intl.dart';
import 'package:html/dom.dart' show Document;
import 'package:meta/meta.dart';

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/entities/week.dart';

import 'utils.dart';

class ScheduleModel extends Schedule {

  static const _titleSelector = 'h3[style]';
  static const _updateTextSelector = 'center > i';
  static const _weeksSelector =
      'select[name=\'weeks\'] > option:not([disabled="disabled"])';

  static String _extractTitle(Document document) {
    final heading = document.querySelector(_titleSelector);
    return heading == null ? null : toLines(heading.text)[2];
  }

  static DateTime _parseDate(String text, RegExp pattern, DateFormat parser) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      return parser.parse(match.group(1));
    }
    return DateTime.now();
  }

  static DateTime _extractUpdateTime(Document document) {
    final element = document.querySelector(_updateTextSelector);
    if (element != null) {
      return _parseDate(element.text, dateTimeExtractor, dateTimeFormat);
    }
    return DateTime.now();
  }

  static List<Week> _extractWeeks(Document document) {
    return document
        .querySelectorAll(_weeksSelector)
        .map((item) => Week(
            id: item.attributes['value'],
            title: item.text,
            startTime: _parseDate(item.text, dateExtractor, dateFormat)))
        .toList();
  }

  factory ScheduleModel.fromDocument(ScheduleParams params, Document document) {
    final title = _extractTitle(document);
    final loaded = title != null;
    return ScheduleModel(
        loaded: loaded,
        id: params.id,
        type: params.type,
        title: title,
        updateTime: loaded ? _extractUpdateTime(document) : null,
        weeks: loaded ? _extractWeeks(document) : null);
  }

  final bool loaded;

  ScheduleModel(
      {@required this.loaded,
      @required String id,
      @required ScheduleType type,
      @required String title,
      @required DateTime updateTime,
      @required List<Week> weeks})
      : super(
            id: id,
            type: type,
            title: title,
            updateTime: updateTime,
            weeks: weeks);
}

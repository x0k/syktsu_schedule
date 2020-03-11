import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:html/dom.dart' show Document;
import 'package:html/parser.dart' show parse;

import 'package:syktsu_schedule/common/pair.dart';

import 'schedule_params.dart';
import 'enums/schedule_type.dart';
import 'model/schedule.dart';
import 'model/week.dart';
import 'model/subgroup.dart';
import 'model/event.dart';

abstract class ScheduleRepository {
  Future<Pair<Schedule, List<Week>>> fetchSchedule(ScheduleParams params);

  Future<Pair<List<SubGroup>, List<Event>>> fetchWeekEvents(Week week);
}

class SyktsuScheduleRepository extends ScheduleRepository {
  static const _rootURL = 'https://campus.syktsu.ru/schedule';
  static const typeNames = const {
    ScheduleType.teacher: 'teacher',
    ScheduleType.classroom: 'classroom',
    ScheduleType.group: 'group'
  };
  static const keysMap = const {
    ScheduleType.teacher: 'name',
    ScheduleType.classroom: 'num_aud',
    ScheduleType.group: 'group'
  };
  static const _updateTextSelector = 'center > i';
  static const _weeksSelector = 'select[name=\'weeks\'] > option:not([disabled="disabled"])';

  static final _dateFormat = DateFormat('dd.MM.yyyy');
  static final _dateExtractor = RegExp(r"(\d{2}\.\d{2}.\d{4})");

  DateTime _extractDate(String text) {
    final match = _dateExtractor.firstMatch(text);
    if (match != null) {
      return _dateFormat.parse(match.group(1));
    }
    return DateTime.now();
  }

  DateTime _extractUpdateTime(Document document) {
    final element = document.querySelector(_updateTextSelector);
    if (element != null) {
      return _extractDate(element.text);
    }
    return DateTime.now();
  }

  List<Week> _extractWeeks(Document document) {
    return document
        .querySelectorAll(_weeksSelector)
        .map((item) =>
            Week(item.attributes['value'], item.text, _extractDate(item.text)))
        .toList();
  }

  @override
  Future<Pair<Schedule, List<Week>>> fetchSchedule(ScheduleParams params) {
    final body = Map<String, String>();
    body[keysMap[params.type]] = params.id;
    final url = '$_rootURL/${typeNames[params.type]}/';
    return http
        .post(url, body: body)
        .then((response) => parse(response.body))
        .then((document) => Pair(
            Schedule(params.id, params.type, _extractUpdateTime(document)),
            _extractWeeks(document)));
  }

  @override
  Future<Pair<List<SubGroup>, List<Event>>> fetchWeekEvents(Week week) {
    // TODO: implement fetchWeekEvents
    throw UnimplementedError();
  }
}

import 'package:intl/intl.dart';

enum ScheduleType { teacher, group, classroom }

const scheduleTypeNames = const {
  ScheduleType.teacher: 'teacher',
  ScheduleType.group: 'group',
  ScheduleType.classroom: 'classroom',
};

const scheduleTypeTitles = const {
  ScheduleType.teacher: 'Преподаватель',
  ScheduleType.classroom: 'Аудитория',
  ScheduleType.group: 'Группа'
};

const scheduleNameTypes = const {
  'teacher': ScheduleType.teacher,
  'classroom': ScheduleType.classroom,
  'group': ScheduleType.group,
};

const numberNames = const {
  1: '08:30-10:00',
  2: '10:10-11:40',
  3: '12:40-14:10',
  4: '14:20-15:50',
  5: '16:00-17:30',
  6: '17:40-19:10',
  7: '19:20-20:50',
  8: '21:00-22:30'
};

final dateTimeFormat = DateFormat('dd.MM.yyyy hh:mm:ss');
final dateFormat = DateFormat('dd.MM.yyyy');
final dateTimeExtractor = RegExp(r"(\d{2}\.\d{2}.\d{4} \d{2}:\d{2}:\d{2})");
final dateExtractor = RegExp(r"(\d{2}\.\d{2}.\d{4})");

class Table {
  static const params = 'params';
  static const version = 'version';
  static const week = 'week';
  static const event = 'event';
  static const paramsVersion = 'params_version';
  static const paramsWeek = 'params_week';
  static const record = 'record';
}

class ParamsTable {
  static const id = 'params_id';
  static const title = 'title';
  static const type = 'type';
}

class VersionTable {
  static const id = 'version_id';
}

class WeekTable {
  static const id = 'week_id';
  static const title = 'title';
  static const startDateTime = 'start_date_time';
}

class EventTable {
  static const id = 'event_id';
  static const day = 'day';
  static const number = 'number';
  static const subject = 'subject';
  static const teacher = 'teacher';
  static const place = 'place';
  static const subGroup = 'sub_group';
}

class ParamsVersionTable {
  static const id = 'params_version_id';
  static const paramsId = 'params';
  static const versionId = 'version';
}

class ParamsWeekTable {
  static const id = 'params_week_id';
  static const paramsId = 'params';
  static const weekId = 'week';
}

class RecordTable {
  static const id = 'record_id';
  static const paramsVersionId = 'params_version';
  static const paramsWeekId = 'params_week';
  static const eventId = 'event';
}

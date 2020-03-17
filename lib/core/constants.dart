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

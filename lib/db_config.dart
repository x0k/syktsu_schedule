const dbName = 'syktsu_schedule.db';
const dbVersion = 1;

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

const sqlCommands = [
  '''
  CREATE TABLE ${Table.params} (
    ${ParamsTable.id} STRING PRIMARY KEY,
    ${ParamsTable.type} STRING,
    ${ParamsTable.title} STRING
  )''',
  '''
  CREATE TABLE ${Table.version} (
    ${VersionTable.id} INTEGER PRIMARY KEY
  )''',
  '''
  CREATE TABLE ${Table.week} (
    ${WeekTable.id} STRING PRIMARY KEY,
    ${WeekTable.title} STRING,
    ${WeekTable.startDateTime} INTEGER
  )''',
  '''
  CREATE TABLE ${Table.event} (
    ${EventTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${EventTable.day} INTEGER,
    ${EventTable.number} INTEGER,
    ${EventTable.subject} STRING,
    ${EventTable.teacher} STRING,
    ${EventTable.place} STRING,
    ${EventTable.subGroup} STRING
  )''',
  '''
  CREATE TABLE ${Table.paramsVersion} (
    ${ParamsVersionTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ParamsVersionTable.paramsId} STRING,
    ${ParamsVersionTable.versionId} INTEGER
  )''',
  '''
  CREATE TABLE ${Table.paramsWeek} (
    ${ParamsWeekTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${ParamsWeekTable.paramsId} STRING,
    ${ParamsWeekTable.weekId} STRING
  )''',
  '''
  CREATE TABLE ${Table.record} (
    ${RecordTable.id} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${RecordTable.paramsVersionId} INTEGER,
    ${RecordTable.paramsWeekId} INTEGER,
    ${RecordTable.eventId} INTEGER
  )'''
];

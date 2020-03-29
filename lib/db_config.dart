import 'core/constants.dart';

const dbName = 'syktsu_schedule.db';
const dbVersion = 1;

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
    ${EventTable.subGroup} STRING,
    UNIQUE(${EventTable.day}, ${EventTable.number}, ${EventTable.subject}, ${EventTable.teacher}, ${EventTable.place}, ${EventTable.subGroup})
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

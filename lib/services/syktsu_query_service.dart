import 'package:sqflite/sqlite_api.dart';

import '../core/constants.dart';
import '../core/entities/event.dart';
import '../core/entities/version.dart';
import '../core/entities/week.dart';
import '../core/entities/schedule_params.dart';
import '../data_sources/services/query_service.dart';
import '../models/event_model.dart';
import '../models/version_model.dart';
import '../models/week_model.dart';
import '../models/schedule_params_model.dart';
import '../db_config.dart';

import 'services/database_provider.dart';

class SyktsuQueryService implements QueryService {
  final DatabaseProvider provider;

  SyktsuQueryService(this.provider);

  Future<List<T>> _makeQuery<T>(String query,
      {T Function(Map<String, dynamic> data) makeModel,
      List<dynamic> arguments}) async {
    final db = await provider.database;
    final items = await db.rawQuery(query, arguments);
    return items.map(makeModel).toList();
  }

  @override
  Future<bool> hasScheduleParams(String paramsId) async {
    final db = await provider.database;
    final paramsList = await db.query(Table.params,
        where: '${ParamsTable.id} = ?', whereArgs: [paramsId]);
    return paramsList.length > 0;
  }

  @override
  Future<List<Event>> getScheduleEvents(
      String paramsId, int versionId, String weekId) {
    return _makeQuery(
      '''SELECT * FROM ${Table.event}
      LEFT JOIN ${Table.record} ON ${RecordTable.eventId} = ${EventTable.id}
      LEFT JOIN ${Table.paramsVersion} ON ${ParamsVersionTable.id} = ${RecordTable.paramsVersionId}
      LEFT JOIN ${Table.paramsWeek} ON ${ParamsWeekTable.id} = ${RecordTable.paramsWeekId}
      WHERE ${Table.paramsVersion}.${ParamsVersionTable.paramsId} = ? AND ${Table.paramsWeek}.${ParamsWeekTable.paramsId} = ? AND ${ParamsVersionTable.versionId} = ? AND ${ParamsWeekTable.weekId} = ?
      ''',
      arguments: [paramsId, paramsId, versionId, weekId],
      makeModel: (event) => EventModel.fromJSON(event),
    );
  }

  @override
  Future<List<Version>> getScheduleVersions(String paramsId) {
    return _makeQuery(
      '''SELECT * FROM ${Table.version}
      LEFT JOIN ${Table.paramsVersion} ON ${ParamsVersionTable.versionId} = ${VersionTable.id}
      WHERE ${ParamsVersionTable.paramsId} = ?
      ''',
      arguments: [paramsId],
      makeModel: (data) => VersionModel.fromJSON(data),
    );
  }

  @override
  Future<List<Week>> getScheduleWeeks(String paramsId) {
    return _makeQuery(
      '''SELECT * FROM ${Table.week}
      LEFT JOIN ${Table.paramsWeek} ON ${ParamsWeekTable.weekId} = ${WeekTable.id}
      WHERE ${ParamsWeekTable.paramsId} = ?
      ''',
      arguments: [paramsId],
      makeModel: (data) => WeekModel.fromJSON(data),
    );
  }

  @override
  Future<List<ScheduleParams>> getScheduleParamsList(
      ScheduleType type, String searchPhrase) {
    return _makeQuery(
      '''SELECT * FROM ${Table.params}
      WHERE ${ParamsTable.type} = ? AND (
        ${ParamsTable.id} LIKE '%$searchPhrase%' OR ${ParamsTable.title} LIKE '%$searchPhrase%'
      )
      ''',
      arguments: [scheduleTypeNames[type]],
      makeModel: (data) => ScheduleParamsModel.fromJSON(data),
    );
  }

  @override
  Future<List<Event>> saveScheduleEvents(
      String paramsId, int versionId, String weekId, List<Event> events) async {
    final db = await provider.database;
    final paramsVersions = await db.query(Table.paramsVersion,
        where:
            '${ParamsVersionTable.paramsId} = ? AND ${ParamsVersionTable.versionId} = ?',
        whereArgs: [paramsId, versionId]);
    final paramsWeeks = await db.query(Table.paramsWeek,
        where:
            '${ParamsWeekTable.paramsId} = ? AND ${ParamsWeekTable.weekId} = ?',
        whereArgs: [paramsId, weekId]);
    final int paramsVersionId = paramsVersions.first[ParamsVersionTable.id];
    final int paramsWeekId = paramsWeeks.first[ParamsWeekTable.id];
    final recordData = {
      RecordTable.paramsVersionId: paramsVersionId,
      RecordTable.paramsWeekId: paramsWeekId
    };
    final batch = db.batch();
    events.forEach((event) {
      batch.insert(Table.event, EventModel.toJSON(event),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    final eventsId = await batch.commit();
    eventsId.forEach((eventId) {
      recordData[RecordTable.eventId] = eventId;
      batch.insert(Table.record, recordData,
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
    return getScheduleEvents(paramsId, versionId, weekId);
  }

  @override
  Future<List<ScheduleParams>> saveScheduleParamsList(
      List<ScheduleParams> paramsList) async {
    final db = await provider.database;
    final batch = db.batch();
    paramsList.forEach((params) {
      batch.insert(Table.params, ScheduleParamsModel.toJSON(params),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
    return paramsList;
  }

  @override
  Future<Version> saveScheduleVersion(String paramsId, Version version) async {
    final db = await provider.database;
    final versionId = await db.insert(
        Table.version, VersionModel.toJSON(version),
        conflictAlgorithm: ConflictAlgorithm.replace);
    final paramsVersionData = {
      ParamsVersionTable.paramsId: paramsId,
      ParamsVersionTable.versionId: versionId
    };
    await db.insert(Table.paramsVersion, paramsVersionData);
    return VersionModel(id: versionId, dateTime: version.dateTime);
  }

  @override
  Future<List<Week>> saveScheduleWeeks(
      String paramsId, List<Week> weeks) async {
    final db = await provider.database;
    final batch = db.batch();
    weeks.forEach((week) {
      batch.insert(Table.week, WeekModel.toJSON(week),
          conflictAlgorithm: ConflictAlgorithm.replace);
    });
    await batch.commit(noResult: true);
    final paramsWeekData = {ParamsWeekTable.paramsId: paramsId};
    weeks.forEach((week) {
      paramsWeekData[ParamsWeekTable.weekId] = week.id;
      batch.insert(Table.paramsWeek, paramsWeekData);
    });
    await batch.commit(noResult: true);
    return weeks;
  }
}

import 'package:sqflite/sqlite_api.dart';

import '../core/constants.dart';
import '../core/entities/event.dart';
import '../core/entities/version.dart';
import '../core/entities/week.dart';
import '../core/entities/schedule_params.dart';
import '../data_sources/services/query_service.dart';

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
      makeModel: (event) => Event.fromJSON(event),
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
      makeModel: (data) => Version.fromJSON(data),
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
      makeModel: (data) => Week.fromJSON(data),
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
      ORDER BY ${ParamsTable.title} ASC
      ''',
      arguments: [scheduleTypeNames[type]],
      makeModel: (data) => ScheduleParams.fromJSON(data),
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
    final eventFindBatch = db.batch();
    events.forEach((event) {
      if (event.subGroup == null) {
        eventFindBatch.query(Table.event,
            columns: [EventTable.id],
            where:
                '${EventTable.day} = ? AND ${EventTable.number} = ? AND ${EventTable.subject} = ? AND ${EventTable.teacher} = ? AND ${EventTable.place} = ? AND ${EventTable.subGroup} IS NULL',
            whereArgs: [
              event.day,
              event.number,
              event.subject,
              event.teacher,
              event.place
            ]);
      } else {
        eventFindBatch.query(Table.event,
            columns: [EventTable.id],
            where:
                '${EventTable.day} = ? AND ${EventTable.number} = ? AND ${EventTable.subject} = ? AND ${EventTable.teacher} = ? AND ${EventTable.place} = ? AND ${EventTable.subGroup} = ?',
            whereArgs: [
              event.day,
              event.number,
              event.subject,
              event.teacher,
              event.place,
              event.subGroup
            ]);
      }
    });
    final localEvents =
        await eventFindBatch.commit();
    final eventsId = await Future.wait(
        List.generate(events.length, (i) => i).map((i) =>
            localEvents[i].length > 0
                ? Future.value(localEvents[i][0][EventTable.id])
                : db.insert(Table.event, Event.toJSON(events[i]))));
    final recordsBatch = db.batch();
    eventsId.forEach((eventId) {
      recordData[RecordTable.eventId] = eventId;
      recordsBatch.insert(Table.record, recordData);
    });
    await recordsBatch.commit(noResult: true);
    return getScheduleEvents(paramsId, versionId, weekId);
  }

  @override
  Future<ScheduleParams> saveScheduleParams(ScheduleParams params) async {
    final db = await provider.database;
    await db.insert(Table.params, ScheduleParams.toJSON(params));
    return params;
  }

  @override
  Future<Version> saveScheduleVersion(String paramsId, Version version) async {
    final db = await provider.database;
    await db.insert(Table.version, Version.toJSON(version),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    final paramsVersionData = {
      ParamsVersionTable.paramsId: paramsId,
      ParamsVersionTable.versionId: version.id.millisecondsSinceEpoch
    };
    await db.insert(Table.paramsVersion, paramsVersionData);
    return version;
  }

  @override
  Future<List<Week>> saveScheduleWeeks(
      String paramsId, List<Week> weeks) async {
    final db = await provider.database;
    final weeksBatch = db.batch();
    weeks.forEach((week) {
      weeksBatch.insert(
        Table.week,
        Week.toJSON(week),
      );
    });
    await weeksBatch.commit(noResult: true);
    final paramsWeekBatch = db.batch();
    final paramsWeekData = {ParamsWeekTable.paramsId: paramsId};
    weeks.forEach((week) {
      paramsWeekData[ParamsWeekTable.weekId] = week.id;
      paramsWeekBatch.insert(Table.paramsWeek, paramsWeekData);
    });
    await paramsWeekBatch.commit(noResult: true);
    return weeks;
  }
}

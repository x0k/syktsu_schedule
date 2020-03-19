import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/entities/version.dart';
import '../core/entities/event.dart';
import '../data/services/schedule_local_data_source.dart';

import 'services/query_service.dart';
import 'syktsu_local_data_source.dart';

class SyktsuScheduleLocalDataSource extends SyktsuLocalDataSource
    implements ScheduleLocalDataSource {
  const SyktsuScheduleLocalDataSource(QueryService queryService)
      : super(queryService);

  @override
  Future<List<Event>> fetchScheduleEvents(
      Schedule schedule, int versionIndex, int weekIndex) {
    final paramsId = schedule.params.id;
    final versionId = schedule.versions[versionIndex].id.millisecondsSinceEpoch;
    final weekId = schedule.weeks[weekIndex].id;
    return queryService.getScheduleEvents(paramsId, versionId, weekId);
  }

  @override
  Future<List<Version>> fetchScheduleVersions(ScheduleParams params) {
    return queryService.getScheduleVersions(params.id);
  }

  @override
  Future<List<Event>> saveScheduleEvents(
      Schedule schedule, int versionIndex, int weekIndex, List<Event> events) async {
    final paramsId = schedule.params.id;
    final versionId = schedule.versions[versionIndex].id.millisecondsSinceEpoch;
    final weekId = schedule.weeks[weekIndex].id;
    return queryService.saveScheduleEvents(paramsId, versionId, weekId, events);
  }

  @override
  Future<Version> saveScheduleVersion(ScheduleParams params, Version version) {
    return queryService.saveScheduleVersion(params.id, version);
  }
}

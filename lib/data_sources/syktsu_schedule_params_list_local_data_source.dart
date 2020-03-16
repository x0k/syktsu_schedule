import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../data/services/schedule_params_list_local_data_source.dart';

import 'services/query_service.dart';
import 'syktsu_local_data_source.dart';

class SyktsuScheduleParamsListLocalDataSource extends SyktsuLocalDataSource
    implements ScheduleParamsListLocalDataSource {
  SyktsuScheduleParamsListLocalDataSource(QueryService queryService)
      : super(queryService);

  @override
  Future<List<ScheduleParams>> fetchScheduleParamsList(
      ScheduleType type, String searchPhrase) {
    return queryService.getScheduleParamsList(type, searchPhrase);
  }

  @override
  Future<List<ScheduleParams>> saveScheduleParamsList(
      List<ScheduleParams> paramsList) {
    return queryService.saveScheduleParamsList(paramsList);
  }

  @override
  Future<Schedule> fetchSchedule(ScheduleParams params) async {
    final hasParams = await queryService.hasScheduleParams(params.id);
    if (hasParams) {
      final versions = await queryService.getScheduleVersions(params.id);
      final weeks = await queryService.getScheduleWeeks(params.id);
      if (versions.length > 0 && weeks.length > 0) {
        return Schedule(params: params, versions: versions, weeks: weeks);
      }
    }
    return null;
  }

  @override
  Future<Schedule> saveSchedule(Schedule schedule) async {
    final paramsList =
        await queryService.saveScheduleParamsList([schedule.params]);
    final params = paramsList.first;
    final versions = await Future.wait(schedule.versions.map(
        (version) => queryService.saveScheduleVersion(params.id, version)));
    final weeks =
        await queryService.saveScheduleWeeks(params.id, schedule.weeks);
    return Schedule(params: params, versions: versions, weeks: weeks);
  }
}

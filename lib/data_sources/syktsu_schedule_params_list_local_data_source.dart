import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/entities/version.dart';
import '../core/entities/week.dart';
import '../data/services/schedule_params_list_local_data_source.dart';
import '../utils.dart';

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
  Future<Schedule> fetchSchedule(ScheduleParams params) async {
    final versions = await queryService.getScheduleVersions(params.id);
    final weeks = await queryService.getScheduleWeeks(params.id);
    return Schedule(params: params, versions: versions, weeks: weeks);
  }

  @override
  Future<Schedule> saveSchedule(Schedule schedule) async {
    final hasScheduleParams =
        await queryService.hasScheduleParams(schedule.params.id);
    final params = hasScheduleParams
        ? schedule.params
        : (await queryService.saveScheduleParams(schedule.params));
    final localVersions = await queryService.getScheduleVersions(params.id);
    final uniqVersions = uniqItems<Version>(localVersions, schedule.versions);
    final localWeeks = await queryService.getScheduleWeeks(params.id);
    final uniqWeeks = uniqItems<Week>(localWeeks, schedule.weeks);
    return Schedule(
        params: params,
        versions: uniqVersions.length > 0
            ? localVersions +
                await Future.wait(uniqVersions.map((version) =>
                    queryService.saveScheduleVersion(params.id, version)))
            : localVersions,
        weeks: uniqWeeks.length > 0
            ? localWeeks +
                await queryService.saveScheduleWeeks(params.id, uniqWeeks)
            : localWeeks);
  }
}

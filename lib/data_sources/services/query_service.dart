import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';
import '../../core/entities/event.dart';
import '../../core/entities/version.dart';
import '../../core/entities/week.dart';

abstract class QueryService {
  Future<bool> hasScheduleParams(String paramsId);
  Future<List<Event>> getScheduleEvents(
      String paramsId, int versionId, String weekId);
  Future<List<Version>> getScheduleVersions(String paramsId);
  Future<List<Week>> getScheduleWeeks(String paramsId);
  Future<List<ScheduleParams>> getScheduleParamsList(
      ScheduleType type, String searchPhrase);

  Future<List<Event>> saveScheduleEvents(
      String paramsId, int versionId, String weekId, List<Event> events);
  Future<List<ScheduleParams>> saveScheduleParamsList(
      List<ScheduleParams> paramsList);
  Future<Version> saveScheduleVersion(String paramsId, Version version);
  Future<List<Week>> saveScheduleWeeks(String paramsId, List<Week> weeks);
}

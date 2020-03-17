import '../../core/entities/event.dart';
import '../../core/entities/schedule.dart';
import '../../core/entities/version.dart';
import '../../core/entities/schedule_params.dart';

abstract class ScheduleLocalDataSource {
  Future<List<Version>> fetchScheduleVersions(ScheduleParams params);
  Future<Version> saveScheduleVersion(ScheduleParams params, Version version);
  Future<List<Event>> fetchScheduleEvents(
      Schedule schedule, int versionIndex, int weekIndex);
  Future<List<Event>> saveScheduleEvents(
      Schedule schedule, int versionIndex, int weekIndex, List<Event> events);
}

import '../../core/entities/schedule_params.dart';
import '../../core/entities/schedule.dart';
import '../../core/entities/event.dart';
import '../../core/entities/version.dart';

abstract class ScheduleRemoteDataSource {
  Future<Version> fetchScheduleVersion(ScheduleParams params);
  Future<List<Event>> fetchScheduleEvents(Schedule schedule, int weekIndex);
}
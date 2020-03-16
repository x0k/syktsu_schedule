import '../core/entities/schedule_params.dart';
import '../core/entities/version.dart';
import '../core/entities/event.dart';
import '../core/entities/schedule.dart';
import '../data/services/schedule_remote_data_source.dart';

import 'services/document_parser.dart';
import 'syktsu_remote_data_source.dart';

class SyktsuScheduleRemoteDataSource implements ScheduleRemoteDataSource {
  static const _eventsField = 'weeks';

  final DocumentParser parser;

  SyktsuScheduleRemoteDataSource(this.parser);

  @override
  Future<Version> fetchScheduleVersion(ScheduleParams params) {
    final body = SyktsuRemoteDataSource.makeScheduleBody(params);
    return SyktsuRemoteDataSource.makeRequest(params.type, body)
        .then((document) => parser.extractVersion(document));
  }

  @override
  Future<List<Event>> fetchScheduleEvents(Schedule schedule, int weekIndex) {
    final body = {_eventsField: schedule.weeks[weekIndex].id};
    return SyktsuRemoteDataSource.makeRequest(schedule.params.type, body)
        .then((document) => parser.extractEvents(document));
  }
}

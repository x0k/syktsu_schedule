import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../models/schedule_model.dart';
import '../models/event_list_model.dart';
import '../data/sources/schedule_remote_data_source.dart';

import 'syktsu_remote_data_source.dart';

class SyktsuScheduleRemoteDataSource extends ScheduleRemoteDataSource {
  static const _EVENTS_FIELD = 'weeks';

  static const _SCHEDULE_TYPE_IDENTITY_FIELDS = const {
    ScheduleType.teacher: 'name',
    ScheduleType.classroom: 'num_aud',
    ScheduleType.group: 'group'
  };

  @override
  Future<ScheduleModel> fetchSchedule(ScheduleParams params) {
    final body = Map<String, String>();
    body[_SCHEDULE_TYPE_IDENTITY_FIELDS[params.type]] = params.id;
    return SyktsuRemoteDataSource.makeRequest(params.type, body)
        .then((document) => ScheduleModel.fromDocument(params, document));
  }

  @override
  Future<EventListModel> fetchScheduleEvents(ScheduleType type, String weekId) {
    final body = Map<String, String>();
    body[_EVENTS_FIELD] = weekId;
    return SyktsuRemoteDataSource.makeRequest(type, body)
        .then((document) => EventListModel.fromDocument(document));
  }
}

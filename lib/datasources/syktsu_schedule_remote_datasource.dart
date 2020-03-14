import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import '../core/constants.dart';
import '../core/errors/exceptions.dart';
import '../core/entities/schedule_params.dart';
import '../data/sources/schedule_remote_data_source.dart';
import '../models/schedule.dart';
import '../models/event_list_model.dart';

import 'constants.dart';

class SyktsuScheduleRemoteDataSource extends ScheduleRemoteDataSource {
  static const _ROOT_URL = 'https://campus.syktsu.ru/schedule';

  static const _SCHEDULE_TYPE_IDENTITY_FIELDS = const {
    ScheduleType.teacher: 'name',
    ScheduleType.classroom: 'num_aud',
    ScheduleType.group: 'group'
  };

  static const _EVENTS_FIELD = 'weeks';

  @override
  Future<ScheduleModel> fetchSchedule(ScheduleParams params) {
    final body = Map<String, String>();
    body[_SCHEDULE_TYPE_IDENTITY_FIELDS[params.type]] = params.id;
    final routeName = SCHEDULE_TYPE_ROUTE_NAMES[params.type];
    final url = '$_ROOT_URL/$routeName/';
    return http
        .post(url, body: body)
        .then((response) => parse(response.body))
        .then((document) => ScheduleModel.fromDocument(params, document))
        .catchError((_) => Future.error(ServerException()));
  }

  @override
  Future<EventListModel> fetchScheduleEvents(ScheduleType type, String weekId) {
    final body = Map<String, String>();
    body[_EVENTS_FIELD] = weekId;
    final routeName = SCHEDULE_TYPE_ROUTE_NAMES[type];
    final url = '$_ROOT_URL/$routeName/';
    return http.post(url, body: body)
      .then((response) => parse(response.body))
      .then((document) => EventListModel.fromDocument(document))
      .catchError((_) => Future.error(ServerException()));
  }
}

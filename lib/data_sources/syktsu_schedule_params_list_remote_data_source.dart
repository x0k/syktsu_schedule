import 'package:html/dom.dart' show Document;

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule.dart';
import '../core/utils.dart';
import '../data/services/schedule_params_list_remote_data_source.dart';

import 'services/document_parser.dart';
import 'syktsu_remote_data_source.dart';

class SyktsuScheduleParamsListRemoteDatasource
    extends ScheduleParamsListRemoteDataSource {
  static const _searchFields = const {
    ScheduleType.group: 'num_group',
    ScheduleType.classroom: 'num_aud',
    ScheduleType.teacher: 'fio'
  };

  final DocumentParser parser;

  SyktsuScheduleParamsListRemoteDatasource(this.parser);

  Schedule _makeSchedule(ScheduleParams params, Document document) {
    return Schedule(
        params: params,
        versions: [parser.extractVersion(document)],
        weeks: parser.extractWeeks(document));
  }

  @override
  Future<ObjectsUnion<List<ScheduleParams>, Schedule>>
      fetchScheduleParamsListOrSchedule(
          ScheduleType type, String searchPhrase) {
    final body = Map<String, String>();
    body[_searchFields[type]] = searchPhrase;
    return SyktsuRemoteDataSource.makeRequest(type, body).then((document) {
      if (parser.hasSchedule(document)) {
        final id = parser.extractScheduleTitle(document);
        return ObjectsUnion(_makeSchedule(
            ScheduleParams(
              id: id,
              type: type,
              title: id,
            ),
            document));
      }
      return ObjectsUnion(parser.extractSchedulePramsList(type, document));
    });
  }

  @override
  Future<Schedule> fetchSchedule(ScheduleParams params) {
    final body = SyktsuRemoteDataSource.makeScheduleBody(params);
    return SyktsuRemoteDataSource.makeRequest(params.type, body)
        .then((document) => _makeSchedule(params, document));
  }
}

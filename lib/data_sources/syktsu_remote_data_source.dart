import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Document;
import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/errors/exceptions.dart';

abstract class SyktsuRemoteDataSource {
  static const _rootUrl = 'https://campus.syktsu.ru/schedule';

  static const _identityFields = const {
    ScheduleType.teacher: 'name',
    ScheduleType.classroom: 'num_aud',
    ScheduleType.group: 'group'
  };

  static Future<Document> makeRequest(
      ScheduleType type, Map<String, String> body) {
    final routeName = scheduleTypeNames[type];
    final url = '$_rootUrl/$routeName/';
    return http.post(url, body: body).then((response) {
      if (response.statusCode == 200) {
        return parse(response.body);
      }
      throw ServerException();
    });
  }

  static Map<String, String> makeScheduleBody(ScheduleParams params) {
    return {_identityFields[params.type]: params.id};
  }
}

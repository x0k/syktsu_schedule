import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' show Document;
import 'package:http/http.dart' as http;

import '../core/constants.dart';
import '../core/errors/exceptions.dart';

abstract class SyktsuRemoteDataSource {
  static const _ROOT_URL = 'https://campus.syktsu.ru/schedule';

  static const SCHEDULE_TYPE_ROUTE_NAMES = const {
    ScheduleType.teacher: 'teacher',
    ScheduleType.classroom: 'classroom',
    ScheduleType.group: 'group'
  };

  static Future<Document> makeRequest(
      ScheduleType type, Map<String, String> body) {
    final routeName = SCHEDULE_TYPE_ROUTE_NAMES[type];
    final url = '$_ROOT_URL/$routeName/';
    return http.post(url, body: body).then((response) {
      if (response.statusCode == 200) {
        return parse(response.body);
      }
      throw ServerException();
    });
  }
}

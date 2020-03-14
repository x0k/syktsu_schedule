import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;

import '../core/constants.dart';
import '../core/errors/exceptions.dart';
import '../models/schedule_params_list_model.dart';
import '../data/sources/schedule_params_list_remote_data_source.dart';

import 'constants.dart';

class SyktsuScheduleParamsListRemoteDatasource extends ScheduleParamsListRemoteDataSource {

  static const _ROOT_URL = 'https://campus.syktsu.ru/schedule';

  static const _SCHEDULE_TYPE_SEARCH_FIELDS = const {
    ScheduleType.group: 'num_group'
  };

  @override
  Future<ScheduleParamsListModel> fetchScheduleParamsList(ScheduleType type, String searchPhrase) {
    final body = Map<String, String>();
    body[_SCHEDULE_TYPE_SEARCH_FIELDS[type]] = searchPhrase;
    final routeName = SCHEDULE_TYPE_ROUTE_NAMES[type];
    final url = '$_ROOT_URL/$routeName/';
    return http.post(url, body: body)
      .then((response) => parse(response.body))
      .then((document) => ScheduleParamsListModel.fromDocument(type, document))
      .catchError((_) => Future.error(ServerException()));
  }

}

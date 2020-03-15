import '../core/constants.dart';
import '../models/schedule_params_list_or_schedule_model.dart';
import '../data/sources/schedule_params_list_remote_data_source.dart';

import 'syktsu_remote_data_source.dart';

class SyktsuScheduleParamsListRemoteDatasource
    extends ScheduleParamsListRemoteDataSource {
  static const _SCHEDULE_TYPE_SEARCH_FIELDS = const {
    ScheduleType.group: 'num_group',
    ScheduleType.classroom: 'num_aud',
    ScheduleType.teacher: 'fio'
  };

  @override
  Future<ScheduleParamsListOrScheduleModel> fetchScheduleParamsListOrSchedule(
      ScheduleType type, String searchPhrase) {
    final body = Map<String, String>();
    body[_SCHEDULE_TYPE_SEARCH_FIELDS[type]] = searchPhrase;
    return SyktsuRemoteDataSource.makeRequest(type, body)
        .then((document) => ScheduleParamsListOrScheduleModel.fromDocument(
            type, searchPhrase, document));
  }
}

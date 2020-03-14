import '../../core/constants.dart';
import '../../models/schedule_params_list_model.dart';

abstract class ScheduleParamsListRemoteDataSource {
  Future<ScheduleParamsListModel> fetchScheduleParamsList(ScheduleType type, String searchPhrase);
}
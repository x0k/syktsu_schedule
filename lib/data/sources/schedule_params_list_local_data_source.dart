import '../../core/constants.dart';
import '../../models/schedule_params_list_model.dart';

abstract class ScheduleParamsListLocalDataSource {
  Future<ScheduleParamsListModel> fetchScheduleParamsList(ScheduleType type, String searchPhrase);
  Future<ScheduleParamsListModel> fetchAllScheduleParamsList();
  Future<void> saveScheduleParamsList(ScheduleParamsListModel);
}
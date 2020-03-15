import '../../core/constants.dart';
import '../../core/entities/schedule_params.dart';
import '../../models/schedule_model.dart';
import '../../models/schedule_params_list_or_schedule_model.dart';

abstract class ScheduleParamsListLocalDataSource {
  Future<ScheduleModel> fetchSchedule(ScheduleParams params);
  Future<ScheduleParamsListOrScheduleModel> fetchScheduleParamsListOrSchedule(ScheduleType type, String searchPhrase);
  Future<ScheduleParamsListOrScheduleModel> fetchAllScheduleParamsList();
}
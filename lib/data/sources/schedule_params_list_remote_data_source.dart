import '../../core/constants.dart';
import '../../models/schedule_params_list_or_schedule_model.dart';

abstract class ScheduleParamsListRemoteDataSource {
  Future<ScheduleParamsListOrScheduleModel> fetchScheduleParamsListOrSchedule(ScheduleType type, String searchPhrase);
}
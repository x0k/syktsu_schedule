import 'package:html/dom.dart' show Document;

import '../core/constants.dart';
import '../core/entities/schedule_params.dart';
import '../core/entities/schedule_params_list.dart';

class ScheduleParamsListModel extends ScheduleParamsList {
  static const _SCHEDULE_TYPE_SELECTORS = const {
    ScheduleType.group: 'button[name=\'group\']'
  };

  factory ScheduleParamsListModel.fromDocument(
      ScheduleType type, Document document) {
    return ScheduleParamsListModel(
        list: document
            .querySelectorAll(_SCHEDULE_TYPE_SELECTORS[type])
            .map((item) =>
                ScheduleParams(id: item.attributes['value'], title: item.text, type: type))
            .toList());
  }

  ScheduleParamsListModel({List<ScheduleParams> list}) : super(list: list);
}

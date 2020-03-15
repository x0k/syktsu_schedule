import 'package:html/dom.dart' show Document;

import '../core/constants.dart';
import '../core/entities/schedule.dart';
import '../core/entities/schedule_params.dart';
import '../core/utils.dart';

import 'schedule_model.dart';

class ScheduleParamsListOrScheduleModel extends ObjectUnion<EntityCollection<ScheduleParams>, Schedule> {
  static const _SCHEDULE_TYPE_SELECTORS = const {
    ScheduleType.group: 'button[name=\'group\']',
    ScheduleType.teacher: 'button[name=\'name\']',
    ScheduleType.classroom: 'button[name=\'aud\']'
  };

  factory ScheduleParamsListOrScheduleModel.fromDocument(
      ScheduleType type, String searchPhrase, Document document) {
    final list = document
        .querySelectorAll(_SCHEDULE_TYPE_SELECTORS[type])
        .map((item) => ScheduleParams(
            id: item.attributes['value'], title: item.text, type: type))
        .toList();
    if (list.length == 0) {
      final params =
          ScheduleParams(id: searchPhrase, title: searchPhrase, type: type);
      final schedule = ScheduleModel.fromDocument(params, document);
      if (schedule.loaded) {
        return ScheduleParamsListOrScheduleModel(schedule);
      }
    }
    return ScheduleParamsListOrScheduleModel(EntityCollection(list));
  }

  ScheduleParamsListOrScheduleModel(Object data) : super(data);
}

import 'package:meta/meta.dart';

import '../../core/entities/schedule.dart';
import '../../core/entities/list_items.dart';

abstract class ScheduleState {
  const ScheduleState();
}

class ScheduleInitial extends ScheduleState {
  const ScheduleInitial();
}

class ScheduleLoading extends ScheduleState {
  const ScheduleLoading();
}

class ScheduleLoaded extends ScheduleState {
  static ScheduleLoaded fromJson(Map<String, dynamic> data) {
    return ScheduleLoaded(
        schedule: Schedule.fromJSON(data['schedule']),
        items: data['items']
            .map((item) => ListItem.fromJSON(item))
            .toList()
            .cast<ListItem>(),
        version: data['version'],
        week: data['week'],
        loading: data['loading']);
  }

  static Map<String, dynamic> toJSON(ScheduleLoaded state) {
    return {
      'schedule': Schedule.toJSON(state.schedule),
      'items': state.items.map((item) => ListItem.toJSON(item)).toList(),
      'version': state.version,
      'week': state.week,
      'loading': state.loading,
    };
  }

  final Schedule schedule;
  final List<ListItem> items;
  final int week;
  final int version;
  final bool loading;
  const ScheduleLoaded(
      {@required this.schedule,
      @required this.items,
      @required this.version,
      @required this.week,
      @required this.loading});
}

class ScheduleError extends ScheduleState {
  final String message;
  const ScheduleError({@required this.message});
}

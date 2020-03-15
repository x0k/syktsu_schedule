import 'package:meta/meta.dart';

import '../constants.dart';

class ScheduleParams {
  final String id;
  final ScheduleType type;
  final String title;
  const ScheduleParams(
      {@required this.id, @required this.type, @required this.title});
}

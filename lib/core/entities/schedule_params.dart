import 'package:meta/meta.dart';

import '../constants.dart';

class ScheduleParams {
  final String id;
  final String title;
  final ScheduleType type;
  ScheduleParams(
      {@required this.type, @required this.title, @required this.id});
}

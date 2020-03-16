import 'package:html/dom.dart' show Document;

import '../../core/constants.dart';
import '../../core/entities/event.dart';
import '../../core/entities/week.dart';
import '../../core/entities/version.dart';
import '../../core/entities/schedule_params.dart';

abstract class DocumentParser {
  List<Event> extractEvents(Document document);
  bool hasSchedule(Document document);
  String extractScheduleTitle(Document document);
  List<ScheduleParams> extractSchedulePramsList(
      ScheduleType type, Document document);
  Version extractVersion(Document document);
  List<Week> extractWeeks(Document document);
}

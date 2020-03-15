import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../constants.dart';

class Event extends Equatable {
  final int day;
  final int number;
  final String subject;
  final String teacher;
  final String place;
  final String subGroup;

  Event(
      {@required this.day,
      @required this.number,
      @required this.teacher,
      @required this.subject,
      @required this.place,
      @required this.subGroup});

  @override
  List<Object> get props => [day, number, subject, place, subGroup];

  String get call => NUM_TO_CALL_MAP[number];
}

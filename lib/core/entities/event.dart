import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

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
}

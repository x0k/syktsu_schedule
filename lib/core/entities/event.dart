import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../constants.dart';

class Event extends Equatable {
  final int id;
  final int day;
  final int number;
  final String subject;
  final String teacher;
  final String place;
  final String subGroup;

  Event(
      {this.id,
      @required this.day,
      @required this.number,
      @required this.teacher,
      @required this.subject,
      @required this.place,
      @required this.subGroup});

  String get numberName => numberNames[number];

  @override
  List<Object> get props => [id];
}

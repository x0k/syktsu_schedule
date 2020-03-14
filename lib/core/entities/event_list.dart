import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'event.dart';

class EventList extends Equatable {
  final List<Event> list;
  EventList({@required this.list});

  @override
  List<Object> get props => [list];
}

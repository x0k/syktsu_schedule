import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import 'date_time.dart';

class Week extends Equatable {
  final String id;
  final String title;
  final EquatableDateTime startDateTime;

  Week({@required this.id, @required this.title, @required this.startDateTime});

  @override
  List<Object> get props => [id];
}

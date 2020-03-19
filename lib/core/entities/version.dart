import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../constants.dart';

import 'date_time.dart';

class Version extends Equatable {
  final EquatableDateTime id;

  const Version({@required this.id});

  String get dateTimeName => dateTimeFormat.format(id);

  @override
  List<Object> get props => [id];
}

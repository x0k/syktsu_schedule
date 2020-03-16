import 'package:meta/meta.dart';

import '../constants.dart';

class Version {
  final int id;
  final DateTime dateTime;

  const Version({this.id, @required this.dateTime});

  String get dateTimeName => dateTimeFormat.format(dateTime);
}

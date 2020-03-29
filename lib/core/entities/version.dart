import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

import '../constants.dart';

import 'date_time.dart';

class Version extends Equatable {
  static Version fromJSON(Map<String, dynamic> data) {
    return Version(
        id: EquatableDateTime.fromMillisecondsSinceEpoch(
            data[VersionTable.id]));
  }

  static Map<String, dynamic> toJSON(Version version) {
    return {
      VersionTable.id: version.id.millisecondsSinceEpoch,
    };
  }

  final EquatableDateTime id;

  const Version({@required this.id});

  String get dateTimeName => dateTimeFormat.format(id);

  @override
  List<Object> get props => [id];
}

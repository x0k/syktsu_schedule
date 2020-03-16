import 'package:meta/meta.dart';

import '../core/entities/version.dart';
import '../db_config.dart';

class VersionModel extends Version {
  VersionModel({int id, @required DateTime dateTime})
      : super(id: id, dateTime: dateTime);

  factory VersionModel.fromJSON(Map<String, dynamic> data) {
    return VersionModel(
        id: data[VersionTable.id],
        dateTime:
            DateTime.fromMillisecondsSinceEpoch(data[VersionTable.dateTime]));
  }

  static Map<String, dynamic> toJSON(Version version) {
    return {
      VersionTable.id: version.id,
      VersionTable.dateTime: version.dateTime.millisecondsSinceEpoch
    };
  }
}

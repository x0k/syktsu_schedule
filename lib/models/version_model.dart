import '../core/entities/version.dart';
import '../core/entities/date_time.dart';
import '../db_config.dart';

class VersionModel {
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
}

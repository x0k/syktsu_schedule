import 'package:flutter_test/flutter_test.dart';

import 'package:syktsu_schedule/core/entities/date_time.dart';
import 'package:syktsu_schedule/core/entities/version.dart';
import 'package:syktsu_schedule/utils.dart';

void main() {
  test('Should get uniq items', () {
    final local = [Version(id: EquatableDateTime.fromMillisecondsSinceEpoch(1584565782000))];
    final remote = [Version(id: EquatableDateTime.fromMillisecondsSinceEpoch(1584565782000))];
    final result = uniqItems<Version>(local, remote);
    expect(result, []);
  });
}
import 'package:flutter_test/flutter_test.dart';

import 'package:syktsu_schedule/core/entities/date_time.dart';

void main() {
  test('Should be equal', () {
    final a = EquatableDateTime.fromMillisecondsSinceEpoch(100);
    final b = EquatableDateTime.fromMillisecondsSinceEpoch(100);
    expect(a == b, true);
  });
}

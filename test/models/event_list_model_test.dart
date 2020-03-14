import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' show parse;

import 'package:syktsu_schedule/models/event_list_model.dart';

import '../fixtures/reader.dart';

void main() {
  test('Should make EventListModel', () {
    final page = fixtureReader('schedule.html');
    final expected = json.encode(json.decode(fixtureReader('event_list.json')));
    final document = parse(page);
    final result = json.encode(EventListModel.fromDocument(document).toJSON());
    expect(result, expected);
  });
}

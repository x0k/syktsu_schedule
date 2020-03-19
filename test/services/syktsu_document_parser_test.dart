import 'package:flutter_test/flutter_test.dart';
import 'package:html/parser.dart' show parse;

import 'package:syktsu_schedule/services/syktsu_document_parser.dart';
import 'package:syktsu_schedule/core/entities/event.dart';

import '../fixtures/reader.dart';

void main() {

  SyktsuDocumentParser parser;

  setUp(() {
    parser = SyktsuDocumentParser();
  });

  test('Should make EventListModel', () {
    final expected = [
      Event(
          id: null,
          day: 2,
          number: 6,
          place: "519/1",
          subGroup: null,
          subject:
              "Многомерный анализ данных и проектирование OLAP-систем (лек.)",
          teacher: "Котелина Н.О."),
      Event(
          id: null,
          day: 2,
          number: 7,
          place: "519/1",
          subGroup: null,
          subject:
              "Многомерный анализ данных и проектирование OLAP-систем (пр.)",
          teacher: "Котелина Н.О."),
      Event(
          id: null,
          day: 3,
          number: 6,
          place: "427/1",
          subGroup: "подгруппа 1",
          subject: "Иностранный язык в профессиональной деятельности (пр.)",
          teacher: "Латыпов Р.А."),
      Event(
          id: null,
          day: 3,
          number: 6,
          place: "225/1",
          subGroup: "подгруппа 2",
          subject: "Иностранный язык в профессиональной деятельности (пр.)",
          teacher: "Вуттке Н.А."),
      Event(
          id: null,
          day: 4,
          number: 6,
          place: "431/1",
          subGroup: null,
          subject: "Межкультурные коммуникации в современном мире (лек.)",
          teacher: "Вокуев Н.Е."),
      Event(
          id: null,
          day: 4,
          number: 7,
          place: "431/1",
          subGroup: null,
          subject: "Межкультурные коммуникации в современном мире (пр.)",
          teacher: "Вокуев Н.Е."),
      Event(
          id: null,
          day: 5,
          number: 6,
          place: "519/1",
          subGroup: null,
          subject: "Высокоуровневое программирование (лек.)",
          teacher: "Миронов В.В."),
      Event(
          id: null,
          day: 5,
          number: 7,
          place: "519/1",
          subGroup: null,
          subject: "Высокоуровневое программирование (лаб.)",
          teacher: "Миронов В.В."),
      Event(
          id: null,
          day: 6,
          number: 4,
          place: "251/1",
          subGroup: null,
          subject: "Методология науки (лек.)",
          teacher: "Тельнова О.П."),
      Event(
          id: null,
          day: 6,
          number: 5,
          place: "251/1",
          subGroup: null,
          subject: "Методология науки (пр.)",
          teacher: "Тельнова О.П.")
    ];
    final events = parser.extractEvents(parse(fixture('schedule.html')));
    expect(events, expected);
  });
}

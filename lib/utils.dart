import 'package:equatable/equatable.dart';

List<T> uniqItems<T extends Equatable>(List<T> store, List<T> items) {
  return items
      .where((newItem) => !store.contains(newItem))
      .toList();
}

dynamic getEnumValue(List<dynamic> values, String value) {
  for (dynamic element in values) {
    if (element.toString() == value) {
      return element;
    }
  }
  return null;
}
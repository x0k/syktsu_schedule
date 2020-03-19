import 'package:equatable/equatable.dart';

List<T> uniqItems<T extends Equatable>(List<T> store, List<T> items) {
  return items
      .where((newItem) => !store.contains(newItem))
      .toList();
}

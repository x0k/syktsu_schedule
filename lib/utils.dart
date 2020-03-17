List<T> uniqItems<T>(List<T> store, List<T> items,
    bool Function(T storeItem, T newItem) comparator) {
  return items
      .where((newItem) =>
          store.firstWhere(
            (storeItem) => comparator(storeItem, newItem),
            orElse: () => null,
          ) ==
          null)
      .toList();
}

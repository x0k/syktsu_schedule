import 'dart:collection';

class ObjectUnion<Left extends Object, Right extends Object> {
  final Object _data;
  const ObjectUnion(this._data);
  isLeft() => _data is Left;
  isRight() => _data is Right;
  Left get left => _data;
  Right get right => _data;
}

class EntityCollection<Entity> extends ListBase<Entity> {
  final List<Entity> _list;

  EntityCollection(this._list);

  @override
  int get length => _list.length;

  @override
  Entity operator [](int index) => _list[index];

  @override
  void operator []=(int index, Entity value) {
    _list[index] = value;
  }

  @override
  void set length(int newLength) {
    _list.length = newLength;
  }
}

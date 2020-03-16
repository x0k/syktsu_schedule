class ObjectsUnion<Left extends Object, Right extends Object> {
  final Object _data;
  const ObjectsUnion(this._data);
  bool isLeft() => _data is Left;
  bool isRight() => _data is Right;
  Left get left => _data;
  Right get right => _data;
}

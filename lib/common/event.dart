class Event<T> {
  T? _value;

  Event(T value) : _value = value;

  T? get value {
    if (_value == null) return null;

    final temp = _value;
    _value = null;

    return temp;
  }
}
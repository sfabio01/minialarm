mixin MapEntryMixin implements MapEntry {}

class CustomMapEntry with MapEntryMixin {
  final String _key;
  final String _value;
  const CustomMapEntry(this._key, this._value) : super();

  @override
  get key => _key;

  @override
  get value => _value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomMapEntry &&
        other.key == _key &&
        other.value == _value;
  }

  @override
  int get hashCode {
    return _key.hashCode ^ _value.hashCode;
  }
}

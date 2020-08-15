import 'package:flutter/widgets.dart';

/// Class that mimics [Map], and notify its listener every time the map is changed.
///
/// This map will notify its listener when a change is detected (an entry has been added, removed, updated, etc... or
/// the map has been sorted, mapped, etc...). However, it won't notify its listener if its items are changed, even if
/// they extends [ChangeNotifier].
class NotifiableMap<K, V> extends ChangeNotifier implements Map<K, V> {
  /// The real map containing the values. Most of the functions in this class just redirect to the functions of this
  /// attribute.
  Map<K, V> _values;

  //region PROPERTIES

  @override
  Iterable<K> get keys => _values.keys;

  @override
  Iterable<V> get values => _values.values;

  @override
  int get length => _values.length;

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  Iterable<MapEntry<K, V>> get entries => _values.entries;

  //endregion

  //region CONSTRUCTORS

  /// Create an empty [NotifiableMap].
  NotifiableMap() : super() {
    _values = Map<K, V>();
  }

  /// Create a [NotifiableMap] by adding all elements of [other] of types [K], [V].
  NotifiableMap.of(Map<K, V> other) : super() {
    _values = Map<K, V>.of(other);
  }

  /// Create a [NotifiableMap] by adding all elements from [other], regardless of their type.
  NotifiableMap.from(Map<K, V> other) : super() {
    _values = Map<K, V>.from(other);
  }

  //endregion

  @override
  NotifiableMap<RK, RV> cast<RK, RV>() =>
      NotifiableMap<RK, RV>.of(_values.cast<RK, RV>());

  @override
  bool containsValue(Object value) => _values.containsValue(value);

  @override
  bool containsKey(Object key) => _values.containsKey(key);

  @override
  NotifiableMap<RK, RV> map<RK, RV>(MapEntry<RK, RV> f(K key, V value)) =>
      NotifiableMap<RK, RV>.of(_values.map(f));

  @override
  void addEntries(Iterable<MapEntry<K, V>> newEntries) {
    _values.addEntries(newEntries);
    notifyListeners();
  }

  @override
  V update(K key, V update(V value), {V ifAbsent()}) {
    V value = _values.update(key, update, ifAbsent: ifAbsent);
    notifyListeners();
    return value;
  }

  @override
  void updateAll(V update(K key, V value)) {
    _values.updateAll(update);
    notifyListeners();
  }

  @override
  void removeWhere(bool predicate(K key, V value)) {
    _values.removeWhere(predicate);
    notifyListeners();
  }

  @override
  V putIfAbsent(K key, V ifAbsent()) {
    V value = _values.putIfAbsent(key, ifAbsent);
    notifyListeners();
    return value;
  }

  @override
  void addAll(Map<K, V> other) {
    _values.addAll(other);
    notifyListeners();
  }

  @override
  V remove(Object key) {
    V value = _values.remove(key);
    notifyListeners();
    return value;
  }

  @override
  void clear() {
    if (isNotEmpty) {
      _values.clear();
      notifyListeners();
    }
  }

  @override
  void forEach(void f(K key, V value)) {
    _values.forEach(f);
    notifyListeners();
  }

  //region OPERATORS

  /// Creates a new [NotifiableMap] that contains the entries of this map and the elements of [other] in that order.
  NotifiableMap<K, V> operator +(NotifiableMap<K, V> other) {
    NotifiableMap<K, V> newSet = NotifiableMap<K, V>.of(_values);
    newSet.addAll(other);
    return newSet;
  }

  @override
  V operator [](Object key) => _values[key];

  @override
  void operator []=(K key, V value) {
    if (_values[key] != value) {
      _values[key] = value;
      notifyListeners();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifiableMap &&
          runtimeType == other.runtimeType &&
          _values == other._values;

  @override
  int get hashCode => _values.hashCode;

  //endregion
}

import 'package:flutter/widgets.dart';

import 'notifiable_list.dart';
import 'notifiable_map.dart';

/// Class that mimics [Set], and notify its listener every time the set is changed.
///
/// This set will notify its listener when a change is detected (an item has been added, removed, updated, etc... or the
/// set has been sorted, mapped, etc...). However, it won't notify its listener if its items are changed, even if they
/// extends [ChangeNotifier].
class NotifiableSet<E> extends ChangeNotifier implements Set<E> {
  /// The real set containing the values. Most of the functions in this class just redirect to the functions of this
  /// attribute.
  Set<E> _values;

  //region PROPERTIES

  @override
  int get length => _values.length;

  @override
  E get first => _values.first;

  @override
  E get last => _values.last;

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  E get single => _values.single;

  @override
  Iterator<E> get iterator => _values.iterator;

  @override
  int get hashCode => _values.hashCode;

  //endregion

  //region CONSTRUCTORS

  /// Create an empty [NotifiableSet].
  NotifiableSet() : super() {
    _values = Set<E>();
  }

  /// Create a [NotifiableSet] by adding all elements of [elements] of type [E].
  NotifiableSet.of(Iterable<E> elements) : super() {
    _values = Set<E>.of(elements);
  }

  /// Create a [NotifiableSet] by adding all elements from [elements], regardless of their type.
  NotifiableSet.from(Iterable<dynamic> elements) : super() {
    _values = Set<E>.from(elements);
  }

  //endregion

  @override
  bool add(E element) {
    if (element == null) throw "element cannot be null";
    bool result = _values.add(element);
    if (result) notifyListeners();
    return result;
  }

  @override
  void addAll(Iterable<E> elements) {
    _values.addAll(elements);
    notifyListeners();
  }

  @override
  void clear() {
    if (length > 0) {
      _values.clear();
      notifyListeners();
    }
  }

  @override
  bool contains(Object E) => _values.contains(E);

  @override
  bool remove(Object E) {
    bool result = _values.remove(E);
    if (result) notifyListeners();

    return result;
  }

  @override
  void forEach(void Function(E element) f) {
    _values.forEach(f);
    notifyListeners();
  }

  @override
  void retainWhere(bool test(E element)) {
    _values.retainWhere(test);
    notifyListeners();
  }

  @override
  void removeWhere(bool test(E element)) {
    _values.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainAll(Iterable<Object> elements) {
    _values.retainAll(elements);
    notifyListeners();
  }

  @override
  void removeAll(Iterable<Object> elements) {
    _values.removeAll(elements);
    notifyListeners();
  }

  /// Set the element at [index] to [newValue].
  ///
  /// The old value at [index] is returned. The listeners will be notified.
  E update(int index, E newValue) {
    E oldValue = elementAt(index);
    replace(elementAt(index), newValue);
    return oldValue;
  }

  /// Replace the [oldValue] with [newValue] if found.
  ///
  ///  The listeners will be notified if [oldValue] is found.
  void replace(E oldValue, E newValue) {
    bool found = false;
    _values = Set<E>.of(_values.map<E>((E e) {
      if (e == oldValue) {
        found = true;
        return newValue;
      } else {
        return e;
      }
    }));

    if (found) notifyListeners();
  }

  //region SET OVERRIDES

  @override
  Set<E> toSet() => Set<E>.of(_values);

  /// Creates a [NotifiableSet] containing the same elements as this set.
  NotifiableSet<E> toNotifiableSet() => NotifiableSet<E>.of(_values);

  @override
  bool any(bool Function(E element) test) => _values.any(test);

  @override
  E elementAt(int index) => _values.elementAt(index);

  @override
  bool every(bool Function(E element) test) => _values.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) => _values.expand<T>(f);

  @override
  E firstWhere(bool Function(E element) test, {E Function() orElse}) => _values.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) => _values.fold<T>(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _values.followedBy(other);

  @override
  String join([String separator = ""]) => _values.join(separator);

  @override
  E lastWhere(bool Function(E element) test, {E Function() orElse}) => _values.lastWhere(test, orElse: orElse);

  @override
  NotifiableSet<T> map<T>(T Function(E e) f) => NotifiableSet<T>.of(_values.map<T>(f));

  @override
  E reduce(E Function(E value, E element) combine) => _values.reduce(combine);

  @override
  E singleWhere(bool Function(E element) test, {E Function() orElse}) => _values.singleWhere(test, orElse: orElse);

  @override
  Iterable<E> skip(int count) => _values.skip(count);

  @override
  Iterable<E> skipWhile(bool Function(E value) test) => _values.skipWhile(test);

  @override
  Iterable<E> take(int count) => _values.take(count);

  @override
  Iterable<E> takeWhile(bool Function(E value) test) => _values.takeWhile(test);

  @override
  List<E> toList({bool growable = true}) => _values.toList(growable: growable);

  /// Create a [NotifiableList] containing the same elements as this set.
  NotifiableList<E> toNotifiableList({bool growable = true}) => NotifiableList.of(_values, growable: growable);

  @override
  Iterable<E> where(bool Function(E element) test) => _values.where(test);

  @override
  Iterable<T> whereType<T>() => _values.whereType<T>();

  /// Return a [Map] where the keys are the indices and the values the elements of this set.
  Map<int, E> asMap() {
    Map<int, E> map = Map<int, E>();
    for (int i = 0; i < length; i++) map[i] = elementAt(i);

    return map;
  }

  /// Return a [NotifiableMap] where the keys are the indices and the values the elements of this set.
  NotifiableMap<int, E> asNotifiableMap() => NotifiableMap<int, E>.of(asMap());

  @override
  NotifiableSet<E> difference(Set<Object> other) => NotifiableSet<E>.of(_values.difference(other));

  @override
  NotifiableSet<E> union(Set<E> other) => NotifiableSet<E>.of(_values.union(other));

  @override
  NotifiableSet<E> intersection(Set<Object> other) => NotifiableSet<E>.of(_values.intersection(other));

  @override
  bool containsAll(Iterable<Object> other) => _values.containsAll(other);

  @override
  E lookup(Object object) => _values.lookup(object);

  /// Iterate over the set and return the first element matching [test].
  ///
  /// If [start] is not null, the starting index will be changed. If no elements match [test], then `-1` is returned.
  int indexWhere(bool test(E element), [int start = 0]) {
    for (int i = start; i < length; i++) {
      E value = elementAt(i);
      if (test(value)) return i;
    }

    return -1;
  }

  /// Search for [element] starting from [start] and return its index.
  ///
  /// If the element does not exist, `-1` is returned.
  int indexOf(E element, [int start = 0]) => indexWhere((value) => element == value, start);

  @override
  NotifiableSet<R> cast<R>() => NotifiableSet<R>.of(_values.cast<R>());

  //endregion

  //region OPERATORS

  /// Creates a new [NotifiableSet] that contains the elements of this set and the elements of [other] in that order.
  NotifiableSet<E> operator +(Iterable<E> other) {
    NotifiableSet<E> newSet = NotifiableSet<E>.of(_values);
    newSet.addAll(other);
    return newSet;
  }

  /// Returns the element at [index].
  E operator [](int index) => _values.elementAt(index);

  /// Update the element at [index] with the new value [value].
  void operator []=(int index, E value) => this.update(index, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NotifiableSet && runtimeType == other.runtimeType && _values == other._values;

  //endregion
}

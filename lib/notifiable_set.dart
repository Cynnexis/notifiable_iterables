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

  int get length => _values.length;

  @override
  E get first => _values.first;

  @override
  E get last => _values.last;

  bool get isEmpty => _values.isEmpty;

  bool get isNotEmpty => _values.isNotEmpty;

  @override
  E get single => _values.single;

  @override
  Iterator<E> get iterator => _values.iterator;

  @override
  int get hashCode => _values.hashCode;

  //endregion

  //region CONSTRUCTORS

  NotifiableSet() : super() {
    _values = Set<E>();
  }

  NotifiableSet.of(Iterable<E> elements) : super() {
    _values = Set<E>.of(elements);
  }

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

  void update(int index, E newValue) {
    replace(elementAt(index), newValue);
  }

  void replace(E oldValue, E newValue) {
    int oldHash = _values.hashCode;
    _values = Set<E>.of(_values.map<E>((E e) {
      if (e == oldValue)
        return newValue;
      else
        return e;
    }));

    if (oldHash != _values.hashCode) notifyListeners();
  }

  //region SET OVERRIDES

  @override
  Set<E> toSet() => Set<E>.of(_values);

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

  NotifiableList<E> toNotifiableList({bool growable = true}) => NotifiableList.of(_values, growable: growable);

  @override
  Iterable<E> where(bool Function(E element) test) => _values.where(test);

  @override
  Iterable<T> whereType<T>() => _values.whereType<T>();

  Map<int, E> asMap() {
    Map<int, E> map = Map<int, E>();
    for (int i = 0; i < length; i++) map[i] = elementAt(i);

    return map;
  }

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

  int indexWhere(bool test(E element), [int start = 0]) {
    for (int i = start; i < length; i++) {
      E value = elementAt(i);
      if (test(value)) return i;
    }

    return -1;
  }

  int indexOf(E element, [int start = 0]) => indexWhere((value) => element == value);

  @override
  NotifiableSet<R> cast<R>() => NotifiableSet<R>.of(_values.cast<R>());

  //endregion

  //region OPERATORS

  NotifiableSet<E> operator +(Iterable<E> other) {
    NotifiableSet<E> newSet = NotifiableSet<E>.of(_values);
    newSet.addAll(other);
    return newSet;
  }

  E operator [](int index) => _values.elementAt(index);

  void operator []=(int index, E value) => this.update(index, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NotifiableSet && runtimeType == other.runtimeType && _values == other._values;

  //endregion
}

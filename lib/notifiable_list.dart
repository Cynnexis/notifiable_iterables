import 'dart:math';

import 'package:flutter/widgets.dart';

import 'notifiable_map.dart';
import 'notifiable_set.dart';

/// Class that mimics [List], and notify its listener every time the list is changed.
///
/// This list will notify its listener when a change is detected (an item has been added, removed, set, etc... or the
/// list has been sorted, mapped, etc...). However, it won't notify its listener if its items are changed, even if they
/// extends [ChangeNotifier].
class NotifiableList<E> extends ChangeNotifier implements List<E> {
  /// The real list containing the values. Most of the functions in this class just redirect to the functions of this
  /// attribute.
  List<E> _values;

  //region PROPERTIES

  @override
  int get length => _values.length;

  @override
  set length(int newLength) {
    if (newLength != length) {
      _values.length = newLength;
      notifyListeners();
    }
  }

  @override
  E get first => _values.first;

  @override
  set first(E value) {
    _values.first = value;
    notifyListeners();
  }

  @override
  E get last => _values.last;

  @override
  set last(E value) {
    _values.last = value;
    notifyListeners();
  }

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  Iterable<E> get reversed => _values.reversed;

  @override
  E get single => _values.single;

  @override
  Iterator<E> get iterator => _values.iterator;

  @override
  int get hashCode => _values.hashCode;

  //endregion

  //region CONSTRUCTORS

  /// Create an empty [NotifiableList].
  ///
  /// If [length] is not null, it will create a fixed-size list. Otherwise, the list will be expandable.
  NotifiableList([int length]) : super() {
    _values = length == null ? List<E>() : List<E>(length);
  }

  /// Create a [NotifiableList] by adding all elements of [elements] of type [E].
  @override
  NotifiableList.of(Iterable<E> elements, {bool growable: true}) : super() {
    _values = List<E>.of(elements, growable: growable);
  }

  /// Create a [NotifiableList] by adding all elements from [elements], regardless of their type.
  @override
  NotifiableList.from(Iterable<dynamic> elements, {bool growable: true}) : super() {
    _values = List<E>.from(elements, growable: growable);
  }

  //endregion

  @override
  void add(E element) {
    if (element == null) throw "element cannot be null";
    _values.add(element);
    notifyListeners();
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
  void replaceRange(int start, int end, Iterable<E> replacement) {
    _values.replaceRange(start, end, replacement);
    notifyListeners();
  }

  @override
  void fillRange(int start, int end, [E fillValue]) {
    _values.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  void removeRange(int start, int end) {
    _values.removeRange(start, end);
    notifyListeners();
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _values.setRange(start, end, iterable, skipCount);
    notifyListeners();
  }

  @override
  E removeLast() {
    E last = _values.removeLast();
    notifyListeners();
    return last;
  }

  @override
  E removeAt(int index) {
    E element = _values.removeAt(index);
    notifyListeners();
    return element;
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _values.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _values.insertAll(index, iterable);
    notifyListeners();
  }

  @override
  void insert(int index, E element) {
    _values.insert(index, element);
    notifyListeners();
  }

  @override
  void shuffle([Random random]) {
    _values.shuffle(random);
    notifyListeners();
  }

  @override
  void sort([int compare(E a, E b)]) {
    _values.sort(compare);
    notifyListeners();
  }

  //region LIST OVERRIDES

  @override
  Set<E> toSet() => _values.toSet();

  /// Creates a [NotifiableSet] containing the same elements as this list.
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
  Iterable<T> map<T>(T Function(E e) f) => _values.map<T>(f);

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

  /// Create a [NotifiableList] containing the same elements as this list.
  NotifiableList<E> toNotifiableList({bool growable = true}) => NotifiableList.of(_values, growable: growable);

  @override
  Iterable<E> where(bool Function(E element) test) => _values.where(test);

  @override
  Iterable<T> whereType<T>() => _values.whereType<T>();

  @override
  Map<int, E> asMap() => _values.asMap();

  /// Return a [NotifiableMap] where the keys are the indices and the values the elements of this list.
  NotifiableMap<int, E> asNotifiableMap() => NotifiableMap<int, E>.of(asMap());

  @override
  Iterable<E> getRange(int start, int end) => _values.getRange(start, end);

  @override
  List<E> sublist(int start, [int end]) => _values.sublist(start, end);

  @override
  int lastIndexOf(E element, [int start]) => _values.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool test(E element), [int start]) => _values.lastIndexWhere(test, start);

  @override
  int indexWhere(bool test(E element), [int start = 0]) => _values.indexWhere(test, start);

  @override
  int indexOf(E element, [int start = 0]) => _values.indexOf(element, start);

  @override
  NotifiableList<R> cast<R>() => NotifiableList<R>.of(_values.cast<R>());

  //endregion

  //region OPERATORS

  @override
  NotifiableList<E> operator +(List<E> other) => NotifiableList<E>.of(_values + other);

  @override
  E operator [](int index) => _values[index];

  @override
  void operator []=(int index, E value) {
    if (_values[index] != value) {
      _values[index] = value;
      notifyListeners();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is NotifiableList && runtimeType == other.runtimeType && _values == other._values;

  //endregion
}

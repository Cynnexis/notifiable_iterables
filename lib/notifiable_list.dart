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
  late List<E> _values;

  /// The boolean that indicates if the notification from its children should
  /// propagate.
  ///
  /// When it is `true` (default value), this [NotifiableList] will notify all
  /// its listeners when a child notify its listeners as well.
  bool _propagateNotification = true;

  //region PROPERTIES

  /// The boolean that indicates if the notification from its children should
  /// propagate.
  ///
  /// When it is `true` (default value), this [NotifiableList] will notify all
  /// its listeners when a child notify its listeners as well.
  bool get propagateNotification => _propagateNotification;

  /// The boolean that indicates if the notification from its children should
  /// propagate.
  ///
  /// When it is `true` (default value), this [NotifiableList] will notify all
  /// its listeners when a child notify its listeners as well.
  set propagateNotification(bool value) {
    if (_propagateNotification != value) {
      _propagateNotification = value;
      if (_propagateNotification)
        _startPropagateNotification();
      else
        _stopPropagateNotification();
    }
  }

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
  /// If [propagateNotification] is `true` (default
  /// value), this [NotifiableList] will notify all its listeners when a child
  /// notify its listeners as well.
  NotifiableList({propagateNotification = true}) : super() {
    _values = <E>[];
    this.propagateNotification = propagateNotification;
  }

  /// Create a [NotifiableList] by adding all elements of [elements] of type [E].
  ///
  /// If [propagateNotification] is `true` (default value), this
  /// [NotifiableList] will notify all its listeners when a child notify its
  /// listeners as well.
  @override
  NotifiableList.of(Iterable<E> elements,
      {bool growable = true, propagateNotification = true})
      : super() {
    _values = List<E>.of(elements, growable: growable);
    this.propagateNotification = propagateNotification;
    if (_propagateNotification) _startPropagateNotification();
  }

  /// Create a [NotifiableList] by adding all elements from [elements], regardless of their type.
  ///
  /// If [propagateNotification] is `true` (default value), this
  /// [NotifiableList] will notify all its listeners when a child notify its
  /// listeners as well.
  @override
  NotifiableList.from(Iterable<dynamic> elements,
      {bool growable = true, propagateNotification = true})
      : super() {
    _values = List<E>.from(elements, growable: growable);
    this.propagateNotification = propagateNotification;
    if (_propagateNotification) _startPropagateNotification();
  }

  //endregion

  /// Callback used for the children when [propagateNotification] is `true`.
  void _propagate() {
    if (_propagateNotification) notifyListeners();
  }

  /// Add the [notifyListeners] method as a listener callback to all children.
  ///
  /// Only the children that are not null and that extends [ChangeNotifier] are
  /// concerned.
  void _startPropagateNotification() {
    for (E element in _values) {
      // Listen to the element if it is possible
      if (element != null && element is ChangeNotifier) {
        element.addListener(_propagate);
      }
    }
  }

  /// Remove the [notifyListeners] method from all children.
  ///
  /// Only the children that are not null and that extends [ChangeNotifier] are
  /// concerned.
  void _stopPropagateNotification() {
    for (E element in _values) {
      // Stop listening to the element if possible
      if (element != null && element is ChangeNotifier) {
        try {
          element.removeListener(_propagate);
        } on AssertionError {}
      }
    }
  }

  @override
  void add(E element) {
    // Listen to the element if asked to and if it is possible
    if (_propagateNotification &&
        element != null &&
        element is ChangeNotifier) {
      element.addListener(_propagate);
    }

    _values.add(element);
    notifyListeners();
  }

  @override
  void addAll(Iterable<E> elements) {
    for (E element in elements) {
      // Listen to the element if asked to and if it is possible
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.addListener(_propagate);
      }

      // Add the element to the list
      _values.add(element);
    }

    // Notify only once
    notifyListeners();
  }

  @override
  void clear() {
    if (length > 0) {
      // Stop listening to children
      _stopPropagateNotification();
      _values.clear();
      notifyListeners();
    }
  }

  @override
  bool contains(Object? E) => _values.contains(E);

  @override
  bool remove(Object? E) {
    // Stop listening to child
    if (_propagateNotification &&
        E != null &&
        E is ChangeNotifier &&
        _values.contains(E)) E.removeListener(_propagate);

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
  void fillRange(int start, int end, [E? fillValue]) {
    _values.fillRange(start, end, fillValue);
    notifyListeners();
  }

  @override
  void removeRange(int start, int end) {
    RangeError.checkValidRange(start, end, length, "start", "end");

    // Stop listening to the element that will be replaced
    for (int i = start; i < end; i++) {
      E element = elementAt(i);
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.removeListener(_propagate);
      }
    }

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
    // Stop listening to child
    if (_propagateNotification && last != null && last is ChangeNotifier)
      last.removeListener(_propagate);

    notifyListeners();
    return last;
  }

  @override
  E removeAt(int index) {
    E element = _values.removeAt(index);
    // Stop listening to child
    if (_propagateNotification && element != null && element is ChangeNotifier)
      element.removeListener(_propagate);

    notifyListeners();
    return element;
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    RangeError.checkValidRange(index, index + iterable.length, length, "index",
        "index + iterable.length");

    // Listen to the element that will be added
    for (E element in iterable) {
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.addListener(_propagate);
      }
    }

    // Stop listening to the element that will be replaced
    for (int i = index; i < index + iterable.length; i++) {
      E element = elementAt(i);
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.addListener(_propagate);
      }
    }

    _values.setAll(index, iterable);
    notifyListeners();
  }

  @override
  void insert(int index, E element) {
    RangeError.checkValidIndex(index, _values, "index", length);

    // Listen to the element if asked to and if it is possible
    if (_propagateNotification &&
        element != null &&
        element is ChangeNotifier) {
      element.addListener(_propagate);
    }

    _values.insert(index, element);
    notifyListeners();
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    for (E element in iterable) {
      // Listen to the element if asked to and if it is possible
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.addListener(_propagate);
      }
    }

    _values.insertAll(index, iterable);
    // Notify only once
    notifyListeners();
  }

  @override
  void shuffle([Random? random]) {
    _values.shuffle(random);
    notifyListeners();
  }

  @override
  void sort([int compare(E a, E b)?]) {
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
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) =>
      _values.expand<T>(f);

  @override
  E firstWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _values.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      _values.fold<T>(initialValue, combine);

  @override
  Iterable<E> followedBy(Iterable<E> other) => _values.followedBy(other);

  @override
  String join([String separator = ""]) => _values.join(separator);

  @override
  E lastWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _values.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E e) f) => _values.map<T>(f);

  @override
  E reduce(E Function(E value, E element) combine) => _values.reduce(combine);

  @override
  E singleWhere(bool Function(E element) test, {E Function()? orElse}) =>
      _values.singleWhere(test, orElse: orElse);

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
  NotifiableList<E> toNotifiableList({bool growable = true}) =>
      NotifiableList.of(_values, growable: growable);

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
  List<E> sublist(int start, [int? end]) => _values.sublist(start, end);

  @override
  int lastIndexOf(E element, [int? start]) =>
      _values.lastIndexOf(element, start);

  @override
  int lastIndexWhere(bool test(E element), [int? start]) =>
      _values.lastIndexWhere(test, start);

  @override
  int indexWhere(bool test(E element), [int start = 0]) =>
      _values.indexWhere(test, start);

  @override
  int indexOf(E element, [int start = 0]) => _values.indexOf(element, start);

  @override
  List<R> cast<R>() => _values.cast<R>();

  //endregion

  //region OPERATORS

  @override
  NotifiableList<E> operator +(List<E> other) =>
      NotifiableList<E>.of(_values + other);

  @override
  E operator [](int index) => _values[index];

  @override
  void operator []=(int index, E value) {
    if (_values[index] != value) {
      // Add/remove listener callback
      if (_propagateNotification) {
        if (_values[index] != null && _values[index] is ChangeNotifier)
          (_values[index] as ChangeNotifier).removeListener(_propagate);

        if (value != null && value is ChangeNotifier)
          value.addListener(_propagate);
      }
      _values[index] = value;
      notifyListeners();
    }
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifiableList &&
          runtimeType == other.runtimeType &&
          _values == other._values;

  //endregion
}

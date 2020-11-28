import 'package:flutter/widgets.dart';

import 'notifiable_list.dart';
import 'notifiable_map.dart';

/// Class that mimics [Set], and notify its listener every time the set is changed.
///
/// This set will notify its listener when a change is detected (an item has been added, removed, updated, etc... or the
/// set has been sorted, mapped, etc...). However, it won't notify its listener if its items are changed, even if they
/// extends [ChangeNotifier].
class NotifiableSet<E> extends ChangeNotifier implements Set<E?> {
  /// The real set containing the values. Most of the functions in this class just redirect to the functions of this
  /// attribute.
  late Set<E?> _values;

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
  E? get first => _values.first;

  @override
  E? get last => _values.last;

  @override
  bool get isEmpty => _values.isEmpty;

  @override
  bool get isNotEmpty => _values.isNotEmpty;

  @override
  E? get single => _values.single;

  @override
  Iterator<E?> get iterator => _values.iterator;

  @override
  int get hashCode => _values.hashCode;

  //endregion

  //region CONSTRUCTORS

  /// Create an empty [NotifiableSet].
  ///
  /// If [propagateNotification] is `true` (default value), this
  /// [NotifiableList] will notify all its listeners when a child notify its
  /// listeners as well.
  NotifiableSet({propagateNotification = true}) : super() {
    _values = Set<E?>();
    this.propagateNotification = propagateNotification;
  }

  /// Create a [NotifiableSet] by adding all elements of [elements] of type [E].
  ///
  /// If [propagateNotification] is `true` (default value), this
  /// [NotifiableList] will notify all its listeners when a child notify its
  /// listeners as well.
  NotifiableSet.of(Iterable<E?> elements, {propagateNotification = true})
      : super() {
    _values = Set<E?>.of(elements);
    this.propagateNotification = propagateNotification;
    if (_propagateNotification) _startPropagateNotification();
  }

  /// Create a [NotifiableSet] by adding all elements from [elements],
  /// regardless of their type.
  ///
  /// If [propagateNotification] is `true` (default value), this
  /// [NotifiableList] will notify all its listeners when a child notify its
  /// listeners as well.
  NotifiableSet.from(Iterable<dynamic> elements, {propagateNotification = true})
      : super() {
    _values = Set<E?>.from(elements);
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
    for (E? element in _values) {
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
    for (E? element in _values) {
      // Stop listening to the element if possible
      if (element != null && element is ChangeNotifier) {
        try {
          element.removeListener(_propagate);
        } on AssertionError {}
      }
    }
  }

  @override
  bool add(E? element) {
    bool result = _values.add(element);

    if (result) {
      // Listen to the element if asked to and if it is possible
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.addListener(_propagate);
      }

      notifyListeners();
    }

    return result;
  }

  @override
  void addAll(Iterable<E?> elements) {
    for (E? element in elements) {
      bool result = _values.add(element);

      // Listen to the element if asked to and if it is possible
      if (result &&
          _propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.addListener(_propagate);
      }
    }

    // Notify only once
    notifyListeners();
  }

  /// Insert [element] in the set at [index].
  ///
  /// If [element] is already in the set, `false` is returned. Otherwise, `true` is returned.
  bool insert(int index, E? element) {
    // If the element is already in the set, stop here
    if (_values.contains(element)) return false;

    // Store all elements from index 0 (included) to [index] (not included).
    Set<E?> prefix = Set<E?>();
    for (int i = 0; i < index; i++) prefix.add(_values.elementAt(i));

    // Store all elements from [index] (included) to the end (included too)
    Set<E?> suffix = Set<E?>();
    for (int i = index; i < _values.length; i++)
      suffix.add(_values.elementAt(i));

    // prefix = [0, 1, 2, ..., index-1]
    // suffix = [index, index+1, ..., length-1]

    // Remove all elements
    _values.clear();

    // Add the prefix
    _values.addAll(prefix);
    // Add the infix ([element])
    bool result = _values.add(element);

    // Listen to the element if asked to and if it is possible
    if (result &&
        _propagateNotification &&
        element != null &&
        element is ChangeNotifier) {
      element.addListener(_propagate);
    }

    // Add the suffix
    _values.addAll(suffix);

    // Notify the listeners
    notifyListeners();

    return true;
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
  void forEach(void Function(E? element) f) {
    _values.forEach(f);
    notifyListeners();
  }

  @override
  void retainWhere(bool test(E? element)) {
    _values.retainWhere(test);
    notifyListeners();
  }

  @override
  void removeWhere(bool test(E? element)) {
    _values.removeWhere(test);
    notifyListeners();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    _values.retainAll(elements);
    notifyListeners();
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    // Stop listening to the element that will be replaced
    for (E? element in elements as Iterable<E?>) {
      if (_propagateNotification &&
          element != null &&
          element is ChangeNotifier) {
        element.removeListener(_propagate);
      }
    }

    _values.removeAll(elements);
    notifyListeners();
  }

  /// Set the element at [index] to [newValue].
  ///
  /// The old value at [index] is returned. The listeners will be notified.
  E? update(int index, E? newValue) {
    E? oldValue = elementAt(index);
    replace(elementAt(index), newValue);
    notifyListeners();
    return oldValue;
  }

  /// Replace the [oldValue] with [newValue] if found.
  ///
  ///  The listeners will be notified if [oldValue] is found.
  void replace(E? oldValue, E? newValue) {
    bool found = false;
    _values = Set<E?>.of(_values.map<E?>((E? e) {
      if (e == oldValue) {
        found = true;
        if (_propagateNotification &&
            oldValue != null &&
            oldValue is ChangeNotifier) {
          oldValue.removeListener(_propagate);
        }
        if (_propagateNotification &&
            newValue != null &&
            newValue is ChangeNotifier) {
          newValue.addListener(_propagate);
        }
        return newValue;
      } else {
        return e;
      }
    }));

    if (found) notifyListeners();
  }

  //region SET OVERRIDES

  @override
  Set<E?> toSet() => Set<E?>.of(_values);

  /// Creates a [NotifiableSet] containing the same elements as this set.
  NotifiableSet<E?> toNotifiableSet() => NotifiableSet<E?>.of(_values);

  @override
  bool any(bool Function(E? element) test) => _values.any(test);

  @override
  E? elementAt(int index) => _values.elementAt(index);

  @override
  bool every(bool Function(E? element) test) => _values.every(test);

  @override
  Iterable<T> expand<T>(Iterable<T> Function(E? element) f) =>
      _values.expand<T>(f);

  @override
  E? firstWhere(bool Function(E? element) test, {E? Function()? orElse}) =>
      _values.firstWhere(test, orElse: orElse);

  @override
  T fold<T>(T initialValue, T Function(T previousValue, E? element) combine) =>
      _values.fold<T>(initialValue, combine);

  @override
  Iterable<E?> followedBy(Iterable<E?> other) => _values.followedBy(other);

  @override
  String join([String separator = ""]) => _values.join(separator);

  @override
  E? lastWhere(bool Function(E? element) test, {E? Function()? orElse}) =>
      _values.lastWhere(test, orElse: orElse);

  @override
  Iterable<T> map<T>(T Function(E? e) f) => _values.map<T>(f);

  @override
  E? reduce(E? Function(E? value, E? element) combine) =>
      _values.reduce(combine);

  @override
  E? singleWhere(bool Function(E? element) test, {E? Function()? orElse}) =>
      _values.singleWhere(test, orElse: orElse);

  @override
  Iterable<E?> skip(int count) => _values.skip(count);

  @override
  Iterable<E?> skipWhile(bool Function(E? value) test) =>
      _values.skipWhile(test);

  @override
  Iterable<E?> take(int count) => _values.take(count);

  @override
  Iterable<E?> takeWhile(bool Function(E? value) test) =>
      _values.takeWhile(test);

  @override
  List<E?> toList({bool growable = true}) => _values.toList(growable: growable);

  /// Create a [NotifiableList] containing the same elements as this set.
  NotifiableList<E?> toNotifiableList({bool growable = true}) =>
      NotifiableList.of(_values, growable: growable);

  @override
  Iterable<E?> where(bool Function(E? element) test) => _values.where(test);

  @override
  Iterable<T> whereType<T>() => _values.whereType<T>();

  /// Return a [Map] where the keys are the indices and the values the elements of this set.
  Map<int, E?> asMap() {
    Map<int, E?> map = Map<int, E?>();
    for (int i = 0; i < length; i++) map[i] = elementAt(i);

    return map;
  }

  /// Return a [NotifiableMap] where the keys are the indices and the values the elements of this set.
  NotifiableMap<int, E?> asNotifiableMap() =>
      NotifiableMap<int, E?>.of(asMap());

  @override
  NotifiableSet<E?> difference(Set<Object?> other) =>
      NotifiableSet<E?>.of(_values.difference(other));

  @override
  NotifiableSet<E?> union(Set<E?> other) =>
      NotifiableSet<E?>.of(_values.union(other));

  @override
  NotifiableSet<E?> intersection(Set<Object?> other) =>
      NotifiableSet<E?>.of(_values.intersection(other));

  @override
  bool containsAll(Iterable<Object?> other) => _values.containsAll(other);

  @override
  E? lookup(Object? object) => _values.lookup(object);

  /// Iterate over the set and return the first element matching [test].
  ///
  /// If [start] is not null, the starting index will be changed. If no elements match [test], then `-1` is returned.
  int indexWhere(bool test(E? element), [int start = 0]) {
    for (int i = start; i < length; i++) {
      E? value = elementAt(i);
      if (test(value)) return i;
    }

    return -1;
  }

  /// Search for [element] starting from [start] and return its index.
  ///
  /// If the element does not exist, `-1` is returned.
  int indexOf(E? element, [int start = 0]) =>
      indexWhere((value) => element == value, start);

  @override
  Set<R> cast<R>() => _values.cast<R>();

  //endregion

  //region OPERATORS

  /// Creates a new [NotifiableSet] that contains the elements of this set and the elements of [other] in that order.
  NotifiableSet<E?> operator +(Iterable<E?> other) {
    NotifiableSet<E?> newSet = NotifiableSet<E?>.of(_values);
    newSet.addAll(other);
    return newSet;
  }

  /// Returns the element at [index].
  E? operator [](int index) => _values.elementAt(index);

  /// Update the element at [index] with the new value [value].
  void operator []=(int index, E? value) => this.update(index, value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotifiableSet &&
          runtimeType == other.runtimeType &&
          _values == other._values;

  //endregion
}

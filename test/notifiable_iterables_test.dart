import 'package:flutter/cupertino.dart';
import 'package:notifiable_iterables/notifiable_iterables.dart';
import 'package:test/test.dart';

Matcher isTrue = equals(true);
Matcher isFalse = equals(false);

void main() {
  List<String> originalList;
  late NotifiableList<String> list1;
  late NotifiableSet<String> set1;
  late NotifiableMap<int, String> map1;

  setUp(() {
    originalList = <String>[
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      "10"
    ];
    list1 = NotifiableList<String>.of(originalList);
    set1 = NotifiableSet<String>.of(originalList);
    map1 = NotifiableMap<int, String>.of(originalList.asMap());
  });

  group("Notifiable List", () {
    test("Notifier", () => testNotifier(list1, "list1"));
    test("Propagation",
        () => testPropagation(NotifiableList<ValueNotifier<String>>()));
    test("Nullity", () => testNullity(list1.cast<String?>()));
  });

  group("Notifiable Set", () {
    test("Notifier", () => testNotifier(set1, "set1"));
    test("Propagation",
        () => testPropagation(NotifiableSet<ValueNotifier<String>>()));
    test("Nullity", () => testNullity(set1.cast<String?>()));

    test("Insert", () async {
      set1.insert(2, "1.5");
      expect(set1[0], equals('0'));
      expect(set1[1], equals('1'));
      expect(set1[2], equals("1.5"));
      expect(set1[3], equals('2'));
      expect(set1[4], equals('3'));
      expect(set1[5], equals('4'));
      expect(set1[6], equals('5'));
      expect(set1[7], equals('6'));
      expect(set1[8], equals('7'));
      expect(set1[9], equals('8'));
      expect(set1[10], equals('9'));
      expect(set1[11], equals('10'));
      expect(set1.length, equals(12));
    });
  });

  group("Notifiable Map", () {
    test("Notifier", () => testNotifier(map1, "map1"));
    test("Nullity", () => testNullity(map1.cast<int?, String?>()));
  });
}

void testNotifier(dynamic iterable, [String name = "iterable"]) {
  bool changed = false;

  void Function() onChanged = () => changed = true;

  expect(changed, isFalse);
  iterable.addListener(onChanged);
  expect(changed, isFalse);
  expect(iterable.length, equals(11));
  expect(changed, isFalse);

  print("$name[0] == \"${iterable[0]}\"");
  expect(changed, isFalse);
  print("$name[0] := \"-1\"");
  iterable[0] = "-1";
  expect(changed, isTrue);
  changed = false;
  print("$name[0] == \"${iterable[0]}\"");
  expect(changed, isFalse);
}

void testPropagation(dynamic iterable) {
  if (iterable is NotifiableList<ValueNotifier> ||
      iterable is NotifiableSet<ValueNotifier>) {
    bool changed = false;

    void Function() onChanged = () => changed = true;

    // Reset the iterable
    iterable.clear();
    iterable.addListener(onChanged);

    // Set boolean values to false
    changed = false;
    bool value1Changed = false;
    bool value2Changed = false;

    // Declare new callbacks for values
    void Function() onValue1Changed = () => value1Changed = true;
    void Function() onValue2Changed = () => value2Changed = true;

    // Declare notifiable values
    ValueNotifier<String> value1 = ValueNotifier("Notifiable value 1");
    ValueNotifier<String> value2 = ValueNotifier("Notifiable value 2");

    // Associate values to callback
    value1.addListener(onValue1Changed);
    value2.addListener(onValue2Changed);

    // Add values to the propagation-allowed iterable
    iterable.propagateNotification = true;
    iterable.add(value1);
    iterable.add(value2);
    expect(changed, isTrue);
    changed = false;

    // Assert all changes are false
    expect(value1Changed, isFalse);
    expect(value2Changed, isFalse);

    // Change value 1
    value1.value = "New notifiable value 1";

    // Expect propagation
    expect(value1Changed, isTrue);
    expect(value2Changed, isFalse);
    expect(changed, isTrue);

    // Reset changes
    changed = false;
    value1Changed = false;

    // Change value 2
    value2.value = "New notifiable value 2";

    // Expect propagation
    expect(value1Changed, isFalse);
    expect(value2Changed, isTrue);
    expect(changed, isTrue);

    // Reset changes
    changed = false;
    value2Changed = false;

    // Turn off propagation
    iterable.propagateNotification = false;

    // Change value 1
    value1.value = "Newer notifiable value 1";

    // Expect no propagation
    expect(value1Changed, isTrue);
    expect(value2Changed, isFalse);
    expect(changed, isFalse);
    value1Changed = false;

    // Change value 2
    value2.value = "Newer notifiable value 2";

    // Expect no propagation
    expect(value1Changed, isFalse);
    expect(value2Changed, isTrue);
    expect(changed, isFalse);
    value2Changed = false;

    // Turn on propagation again
    iterable.propagateNotification = true;

    // Change value 1
    value1.value = "New notifiable value 1";

    // Expect propagation
    expect(value1Changed, isTrue);
    expect(value2Changed, isFalse);
    expect(changed, isTrue);

    // Reset changes
    changed = false;
    value1Changed = false;

    // Change value 2
    value2.value = "New notifiable value 2";

    // Expect propagation
    expect(value1Changed, isFalse);
    expect(value2Changed, isTrue);
    expect(changed, isTrue);
  } else {
    assert(iterable is NotifiableMap,
        "iterable type not valid: ${iterable.runtimeType}");
  }
}

void testNullity(dynamic iterable) {
  if (iterable is Map) {
    iterable[null] = null;
    expect(iterable[null], isNull);
  } else {
    iterable.add(null);
    expect(iterable.last, isNull);
  }
}

class ValueNotifier<T> extends ChangeNotifier {
  T _value;

  T get value => _value;

  set value(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      notifyListeners();
    }
  }

  ValueNotifier(this._value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ValueNotifier &&
          runtimeType == other.runtimeType &&
          _value == other._value;

  @override
  int get hashCode => _value.hashCode;

  @override
  String toString() {
    return "${runtimeType.toString()}($_value)";
  }
}

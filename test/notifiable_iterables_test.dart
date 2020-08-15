import 'package:notifiable_iterables/notifiable_iterables.dart';
import 'package:test/test.dart';

Matcher isTrue = equals(true);
Matcher isFalse = equals(false);

void main() {
  List<String> originalList;
  NotifiableList<String> list1;
  NotifiableSet<String> set1;
  NotifiableMap<int, String> map1;

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
    test("Nullity", () => testNullity(set1));
  });

  group("Notifiable Set", () {
    test("Notifier", () => testNotifier(set1, "set1"));
    test("Nullity", () => testNullity(set1));

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
    test("Nullity", () => testNullity(map1));
  });
}

void testNotifier(dynamic iterable, [String name = "iterable"]) {
  assert(name != null);
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

void testNullity(dynamic iterable) {
  if (iterable is Map) {
    iterable[null] = null;
    expect(iterable[null], isNull);
  } else {
    iterable.add(null);
    expect(iterable.last, isNull);
  }
}

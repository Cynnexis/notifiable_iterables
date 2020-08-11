import 'package:notifiable_iterables/notifiable_list.dart';
import 'package:notifiable_iterables/notifiable_set.dart';
import 'package:notifiable_iterables/notifiable_map.dart';
import 'package:test/test.dart';

Matcher isTrue = equals(true);
Matcher isFalse = equals(false);

void main() {
  List<String> originalList = <String>['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', "10"];
  NotifiableList<String> list1 = NotifiableList<String>.of(originalList);
  NotifiableSet<String> set1 = NotifiableSet<String>.of(originalList);
  NotifiableMap<int, String> map1 = NotifiableMap<int, String>.of(originalList.asMap());

  group("Notifiable List", () {
    test("Notifier", () async {
      testNotifier(list1, "list1");
    });
  });

  group("Notifiable Set", () {
    test("Notifier", () async {
      testNotifier(set1, "set1");
    });
  });

  group("Notifiable Map", () {
    test("Notifier", () async {
      testNotifier(map1, "map1");
    });
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

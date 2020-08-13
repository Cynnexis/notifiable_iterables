# notifiable_iterables

![Notifiable Iterables CI/CD](https://github.com/Cynnexis/notifiable_iterables/workflows/Notifiable%20Iterables%20CI/CD/badge.svg) ![language: dart](https://img.shields.io/badge/lang-dart-03599C) ![sdk: flutter](https://img.shields.io/badge/sdk-flutter-45D1FD.svg) ![license: BSD](https://img.shields.io/badge/license-BSD-blue.svg)

Provides iterables that implements the [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) class.

**pub.dev:** https://pub.dev/packages/notifiable_iterables

**GitHub:** https://github.com/Cynnexis/notifiable_iterables

## Getting Started

### Installation

### Pub

It is recommended to install this package via `pub`.

To install this package in your project, open the `pubspec.yaml`, see [this section](https://pub.dev/packages/notifiable_iterables/install).

### Running the Example

The `example/` directory contains an *Android Studio* project that uses `notifiable_iterables`.
To make it run, open the project using *Android Studio* to launch the configuration **example**.

![Buttons describing the configuration "example" on Android Studio.](https://i.imgur.com/9et70cR.png)

If you don't have *Android Studio*, please open a terminal in the `example` project directory, and execute the following lines:

```bash
# Get the dependencies
pub get

# Check that a device is connected to this computer
flutter devices

# Run the example
flutter run
```

## Usage

The full documentation is available [here](https://pub.dev/documentation/notifiable_iterables/latest/).

To use this library, you need to import it in your dart file:

```dart
import 'package:notifiable_iterables/notifiable_iterables.dart';
```

Then, you can use the following classes:

1. `NotifiableList<E>`: A notifiable list. It has the same functions as [`List<E>`](https://api.flutter.dev/flutter/dart-core/List-class.html).
2. `NotifiableSet<E>`: A notifiable set. It has the same functions as [`Set<E>`](https://api.flutter.dev/flutter/dart-core/Set-class.html).
3. `NotifiableMap<K, V>`: A notifiable map. It has the same functions as [`Map<K, V>`](https://api.flutter.dev/flutter/dart-core/Map-class.html).

Those classes can be uses exactly like their iterable equivalent.

**Example:**

```dart
// Create a notifiable list
NotifiableList<int> list = NotifiableList<int>.of(<int>[0, 1, 2, 3]);
print(list[2].toString()); // prints "2"

// Add a listener
list.addListener(() => print("New list: $list"));

// Change the list
list[3] = 4; // Notify the listeners, the console will show the updated list
```

## Build With

* [Dart](https://dart.dev/)
* [Flutter](https://flutter.dev/)
* [Android Studio](https://developer.android.com/studio)

## Author

* **Valentin Berger ([Cynnexis](https://github.com/Cynnexis)):** developer

## License

This project is under the BSD License. Please see the
[LICENSE.txt](https://github.com/Cynnexis/notifiable_iterables/blob/master/LICENSE.txt) file for
more detail (it's a really fascinating story written in there!)

# notifiable_iterables

Provides iterables that implements the [`ChangeNotifier`](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html) class.

## Getting Started

### Installation

This package is not on [pub.dev](https://pub.dev/) yet.

If you want to install it locally on your machine, follow the following steps:

1. Clone this project wherever you want on your computer:
    ```bash
   git clone https://github.com/Cynnexis/notifiable_iterables.git 
   ```
2. In your flutter project, add the following snippet in your `pubspec.yaml`:
    ```yaml
   dependencies:
     notifiable_iterables:
       path: path/to/notifiable_iterables
   ```
   If you have problems at the step, please check the [`pubspec.yaml` of the example](https://github.com/Cynnexis/notifiable_iterables/blob/master/example/pubspec.yaml).
3. Open a terminal in your flutter project directory, and enter `pub get`.

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

To use this library, you need to import it in your dart file:

```dart
// NotifiableList
import 'package:notifiable_iterables/notifiable_list.dart';

// NotifiableSet
import 'package:notifiable_iterables/notifiable_set.dart';

// NotifiableMap
import 'package:notifiable_iterables/notifiable_Map.dart';
```

Then, you can use the following classes:

1. `NotifiableList<E>`: A notifiable list. It has the same functions as [`List<E>`](https://api.flutter.dev/flutter/dart-core/List-class.html).
2. `NotifiableSet<E>`: A notifiable set. It has the same functions as [`Set<E>`](https://api.flutter.dev/flutter/dart-core/Set-class.html).
3. `NotifiableMap<K, V>`: A notifiable map. It has the same functions as [`Map<K, V>`](https://api.flutter.dev/flutter/dart-core/Map-class.html).

Those classes can be uses exactly like their iterable equivalent.

**Example:**

```dart
NotifiableList<int> list = NotifiableList<int>.of(<int>[0, 1, 2, 3]);
print(list[2].toString()); // prints "2"
list[3] = 4; // Notify the listeners
```

## Build With

* [Dart](https://dart.dev/)
* [Flutter](https://flutter.dev/)
* [Android Studio](https://developer.android.com/studio)

## Author

* **Valentin Berger ([Cynnexis](https://github.com/Cynnexis)):** developer

## License

This project is under the MIT License. Please see the [LICENSE.txt](https://github.com/Cynnexis/notifiable_iterables/blob/master/LICENSE.txt) file for more detail (it's a really fascinating story written in there!)

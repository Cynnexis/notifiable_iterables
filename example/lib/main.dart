import 'dart:async';

import 'package:flutter/material.dart';
import 'package:notifiable_iterables/notifiable_iterables.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final String appName = "Example for Notifiable Iterables";

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<NotifiableList<BigInt>>(
      create: (context) => NotifiableList<BigInt>(),
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage(title: appName),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  /// Variable holding the fibonacci stream
  late Stream<BigInt> fibonacciStream;

  /// Variable holding the subscription to the fibonacci stream. It can control the stream by pausing it or resuming it.
  late StreamSubscription<BigInt> fibonacciStreamSubscription;

  @override
  void initState() {
    super.initState();
    // Launch the fibonacci stream.
    fibonacciStream = fibonacci(interval: Duration(seconds: 1));
    fibonacciStreamSubscription =
        fibonacciStream.listen(onFibonacciNumberIsComputed);
  }

  /// Callback for the fibonacci stream.
  ///
  /// It add the newly computed fibonacci number to the [NotifiableList]. The list then notify the UI.
  void onFibonacciNumberIsComputed(BigInt fibonacciNumber) {
    Provider.of<NotifiableList<BigInt>>(context, listen: false)
        .add(fibonacciNumber);
  }

  @override
  void dispose() {
    super.dispose();
    // Stop the stream
    fibonacciStreamSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          // Button in the appbar to reset the fibonacci stream and list
          IconButton(
            icon: Icon(Icons.replay),
            onPressed: () => setState(() {
              fibonacciStreamSubscription.cancel();
              Provider.of<NotifiableList<BigInt>>(context, listen: false)
                  .clear();
              fibonacciStream = fibonacci(interval: Duration(seconds: 1));
              fibonacciStreamSubscription = fibonacciStream.listen((event) {
                Provider.of<NotifiableList<BigInt>>(context, listen: false)
                    .add(event);
              });
            }),
          ),
        ],
        // Loading bar to show whether the stream is activated or not
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 6.0),
          child: LinearProgressIndicator(
            backgroundColor: Colors.lightBlueAccent.withOpacity(0.3),
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
            value: fibonacciStreamSubscription.isPaused ? 0.0 : null,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("The fibonacci numbers are:"),
              Consumer<NotifiableList<BigInt>>(
                builder: (context, fibNumbers, _) => ListView.separated(
                  itemCount: fibNumbers.length,
                  separatorBuilder: (context, index) => Divider(height: 2),
                  // Disable scroll because its parent is a Column
                  physics: NeverScrollableScrollPhysics(),
                  // Shrink the list
                  shrinkWrap: true,
                  itemBuilder: (context, index) => ListTile(
                    leading: Container(
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(200)),
                        color: Colors.grey.withAlpha(100),
                      ),
                      child: Text("#${index + 1}"),
                    ),
                    title: Text(fibNumbers[index].toString()),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Button to pause and resume the stream
      floatingActionButton: FloatingActionButton(
        child: Icon(fibonacciStreamSubscription.isPaused
            ? Icons.play_arrow
            : Icons.pause),
        tooltip: fibonacciStreamSubscription.isPaused
            ? "Resume the computation"
            : "Pause the computation",
        onPressed: () => setState(() => fibonacciStreamSubscription.isPaused
            ? fibonacciStreamSubscription.resume()
            : fibonacciStreamSubscription.pause()),
      ),
    );
  }
}

/// The fibonacci function.
///
/// This functions computes the first [n] fibonacci numbers. If [n] is not given, it will never stop. This function
/// yields every new results through a stream of [BigInt]. If [interval] is given, a delay will be respected between
/// two computation.
Stream<BigInt> fibonacci({int? n, Duration? interval}) async* {
  BigInt a = BigInt.from(0);
  BigInt b = BigInt.from(1);

  yield a;
  if (interval != null) await Future.delayed(interval);
  yield b;
  if (interval != null) await Future.delayed(interval);

  int counter = 0;
  while (n == null || counter < n) {
    BigInt c = BigInt.parse(a.toString());
    a = b;
    b = c + b;
    yield b;
    counter++;

    if (interval != null) await Future.delayed(interval);
  }
}

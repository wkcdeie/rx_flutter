import 'package:flutter/material.dart';
import 'package:rx_flutter/rx_flutter.dart';

final rxNavigator = RxNavigatorObserver();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      navigatorObservers: [rxNavigator],
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _counter = [0, 1, 2].rx;
  final _switchValue = false.rx;
  final _checkboxValue = NullableSubject<bool>.from(null);

  @override
  void dispose() {
    _checkboxValue.close();
    _switchValue.close();
    _counter.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () => showLicensePage(context: context),
            icon: const Icon(Icons.copyright),
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            RxWidget(
              subject: _counter,
              builder: (_, value) => Text(
                '$value',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            RxWidget<Route>(
              subject: rxNavigator.asObserver(),
              builder: (_, value) => Text(
                '${value.hashCode}',
                style: Theme.of(context).textTheme.headline4,
              ),
            ),
            RxWidget<bool>(
              subject: _switchValue,
              builder: (_, value) => SwitchListTile(
                value: value,
                onChanged: _switchValue.valueChanged,
              ),
            ),
            RxWidget<bool?>(
              subject: _checkboxValue,
              builder: (_, value) => CheckboxListTile(
                value: value,
                onChanged: _checkboxValue.valueChanged,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        onPressed: () {
          _counter.value.add(_counter.value.length + 1);
        },
      ),
    );
  }
}

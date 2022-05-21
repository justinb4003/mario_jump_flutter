import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sounds',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mario'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static AudioCache audioPlayer = AudioCache();
  bool _isActive = false;
  String _totalG = "0";
  double _targetG = 3.0;
  int _lastPlay = 0;
  final int _lockoutMs = 1000;

  void playLocal() async {
    await audioPlayer.play('mario_jump_small.wav');
  }

  @override
  void initState() {
    super.initState();
    print('init hit');
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      setState(() {
        _totalG = event.x.abs().toStringAsFixed(1);
      });
      if (event.x.abs() > _targetG && _isActive) {
        if (_lastPlay + _lockoutMs < DateTime.now().millisecondsSinceEpoch) {
          _lastPlay = DateTime.now().millisecondsSinceEpoch;
          playLocal();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Mario Mode',
            ),
            Text(
              _isActive ? 'Active' : 'Inactive',
              style: Theme.of(context).textTheme.caption,
            ),
            Switch(
              value: _isActive,
              onChanged: (bool value) {
                setState(() {
                  _isActive = value;
                });
              },
            ),
            const Text(
              'Activation Gs',
            ),
            Slider(
                value: _targetG,
                min: 1.0,
                max: 10,
                divisions: 20,
                label: _targetG.toStringAsFixed(1),
                onChanged: (double v) {
                  setState(() => _targetG = v);
                }),
            const Text(
              'Current Gs',
            ),
            Text(
              _totalG,
            ),
          ],
        ),
      ),
    );
  }
}

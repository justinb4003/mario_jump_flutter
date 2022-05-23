import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String _handMode = "A";
  String _debugMsg = "";
  double _targetG = 3.0;
  int _lastPlay = 0;
  final int _lockoutMs = 600;

  void playLocal() async {
    await audioPlayer.play('mario_jump_small.wav');
  }

  void loadPreferences() {
    SharedPreferences.getInstance().then((prefs) {
      setState(() {
        _targetG = prefs.getDouble('targetG') ?? 3.0;
        _handMode = prefs.getString('handMode') ?? "A";
      });
    });
  }

  void savePreferences() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setDouble('targetG', _targetG);
      prefs.setString('handMode', _handMode);
    });
  }

  @override
  void initState() {
    super.initState();
    loadPreferences();
    print('init hit');
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      print(event.x);
      double currentX = event.x;
      setState(() {
        _totalG = currentX.abs().toStringAsFixed(1);
      });
      bool accelHit = false;
      bool snapHit = false;
      switch (_handMode) {
        case "A":
          accelHit = currentX.abs() > _targetG;
          if (accelHit) {
            _debugMsg = "Mode A, ${currentX.abs()} > $_targetG";
          }
          break;
        case "L":
          accelHit = currentX > _targetG;
          snapHit = currentX < -_targetG;
          if (accelHit) {
            _debugMsg = "Mode L, $currentX > $_targetG";
          }
          break;
        case "R":
          accelHit = currentX < -_targetG;
          snapHit = currentX > _targetG;
          if (accelHit) {
            _debugMsg = "Mode R, $currentX < ${-_targetG}";
          }
          break;
      }
      int now = DateTime.now().millisecondsSinceEpoch;
      if (snapHit) {
        _lastPlay = now;
      }
      if (accelHit && _isActive) {
        if (_lastPlay + _lockoutMs < now) {
          _lastPlay = now;
          playLocal();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 30),
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
            Text(
              _debugMsg,
            ),
            ListTile(
              title: const Text(
                'Left Hand',
                style: TextStyle(fontSize: 12),
              ),
              leading: Radio(
                value: 'L',
                groupValue: _handMode,
                onChanged: (v) {
                  setState(() {
                    _handMode = v.toString();
                    savePreferences();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Right Hand',
                style: TextStyle(fontSize: 12),
              ),
              leading: Radio(
                value: 'R',
                groupValue: _handMode,
                onChanged: (v) {
                  setState(() {
                    _handMode = v.toString();
                    savePreferences();
                  });
                },
              ),
            ),
            ListTile(
              title: const Text(
                'Ambidextrous',
                style: TextStyle(fontSize: 12),
              ),
              leading: Radio(
                value: 'A',
                groupValue: _handMode,
                onChanged: (v) {
                  setState(() {
                    _handMode = v.toString();
                    savePreferences();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

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
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Mario'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static AudioCache audioPlayer = AudioCache();
  final int _lockoutMs = 600;
  String _totalG = "0";
  String _handMode = "A";
  double _targetG = 3.0;
  int _lastPlay = 0;
  bool _isActive = false;

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
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      double currentX = event.x;
      setState(() {
        _totalG = currentX.abs().toStringAsFixed(1);
      });
      bool accelHit = false;
      bool snapHit = false;
      switch (_handMode) {
        case "A":
          accelHit = currentX.abs() > _targetG;
          break;
        case "L":
          accelHit = currentX > _targetG;
          snapHit = currentX < -_targetG;
          break;
        case "R":
          accelHit = currentX < -_targetG;
          snapHit = currentX > _targetG;
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
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
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

import 'package:flutter/material.dart';
import 'package:test_drive/page/camera_page.dart' as camera;
import 'package:test_drive/page/sessions.dart' as sessions;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  camera.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NumVisor',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const sessions.Sessions(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Num Visor'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const sessions.Sessions()),
                );
              },
              child: const Text('Sessions'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecondScreen()),
                );
              },
              child: const Text('Sessions'),
            ),
          ],
        ),
      ),
    );
  }
}


class SecondScreen extends StatelessWidget {
  const SecondScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sessions'),
      ),
      body: const Center(
        child: Text(
          'Это второе окно',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:test_drive/page/camera_page.dart' as camera;
import 'package:test_drive/page/sessions.dart' as sessions;
import 'package:test_drive/service/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  camera.init();
  service = await SessionService.loadFromSharedPreferences();
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
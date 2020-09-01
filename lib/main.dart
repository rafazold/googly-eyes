import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:looney_cam/pages/addVoice.dart';
import 'package:looney_cam/pages/displayResult.dart';
import 'package:looney_cam/pages/videoApp.dart';
import 'package:looney_cam/pages/home.dart';
import 'package:looney_cam/pages/makeImage.dart';
import 'package:looney_cam/pages/start.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(initialRoute: '/start', routes: {
      '/start': (context) => Start(),
      '/home': (context) => Home(),
      '/image': (context) => MakeImage(),
      '/video': (context) => VideoApp(),
      '/result': (context) => DisplayResult(),
    }));
  });
}

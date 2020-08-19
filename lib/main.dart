import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:googly_eyes/pages/addVoice.dart';
import 'package:googly_eyes/pages/videoApp.dart';
import 'package:googly_eyes/pages/home.dart';
import 'package:googly_eyes/pages/makeImage.dart';
import 'package:googly_eyes/pages/start.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MaterialApp(initialRoute: '/start', routes: {
      '/start': (context) => Start(),
      '/home': (context) => Home(),
      '/image': (context) => MakeImage(),
      '/voice': (context) => AddVoice(),
      '/video': (context) => VideoApp(),
    }));
  });
}

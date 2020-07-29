import 'package:flutter/material.dart';
import 'package:googly_eyes/pages/addVoice.dart';
import 'package:googly_eyes/pages/fbShare.dart';
import 'package:googly_eyes/pages/home.dart';
import 'package:googly_eyes/pages/makeImage.dart';

void main() => runApp(MaterialApp(initialRoute: '/home', routes: {
      '/home': (context) => Home(),
      '/image': (context) => MakeImage(),
      '/voice': (context) => AddVoice(),
      '/fbshare': (context) => FbShare(),
    }));

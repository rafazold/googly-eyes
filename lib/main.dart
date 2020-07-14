import 'package:flutter/material.dart';
import 'package:googly_eyes/pages/home.dart';

void main() => runApp(MaterialApp(initialRoute: '/home', routes: {
      '/home': (context) => Home(),
    }));

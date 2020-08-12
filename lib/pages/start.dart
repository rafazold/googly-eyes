import 'package:flutter/material.dart';
import 'package:googly_eyes/pages/splash.dart';

class Start extends StatelessWidget {
  const Start({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Splash(
      pageTitle: 'Click to begin',
      pressFunction: (context) {
        print('starting');
        Navigator.pushNamed(context, '/home');
      },
      useContext: true,
    ));
  }
}

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/countdownTimer.dart';

class PopupAlert {
  void textAlert(BuildContext context, message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // title: Text('Not in stock'),
          content: Text(message),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                closeModal(context);
              },
            ),
          ],
        );
      },
    );
  }

  void childAlert(BuildContext context) {
    print('dialog started');
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Center(child: Container(height: 180, child: CountDownTimer()));
      },
    );
    // Timer(Duration(milliseconds: 3800), () {
    //   print('yeah');
    //   Navigator.of(context).pop();
    // });
  }

  void closeModal(context) {
    print('waka waka');
    // Navigator.of(context, rootNavigator: true).pop();
    print('waka waka222222222222222');
  }
}

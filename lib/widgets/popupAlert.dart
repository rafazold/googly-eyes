// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:looney_cam/widgets/countdownTimer.dart';

class PopupAlert {
  void textAlert(BuildContext context,
      {String message, List<Widget> buttons, String closeButton}) {
    print('this is an alert');
    List<Widget> actionButtons = buttons != null ? buttons : [];

    if (closeButton != null) {
      actionButtons.add(FlatButton(
        child: Text(closeButton),
        onPressed: () {
          closeModal(context);
        },
      ));
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // title: Text('Not in stock'),
          content: Text(message),
          actions: actionButtons,
        );
      },
    );
  }

  void childAlert(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print('dialog started');
    showDialog(
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 160),
          // backgroundColor: Colors.transparent,
          // type: MaterialType.canvas,
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffff0077), Color(0xffff724e)],
                      stops: [0, 1],
                      begin: Alignment(-0.93, 0.36),
                      end: Alignment(0.93, -0.36),
                    ),
                    // border:
                  ),
                  height: height - 320,
                  width: width - 80,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.open_with,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              'Sweap to change set',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.settings_ethernet,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              'Sweap to explore Looney elements',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              'Long Press Looney element and drag to the desired location',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.zoom_out_map,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              'Pinch to zoom in and out',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ))),
        );
      },
    );
    // Timer(Duration(milliseconds: 3800), () {
    //   print('yeah');
    //   Navigator.of(context).pop();
    // });
  }

  void closeModal(context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}

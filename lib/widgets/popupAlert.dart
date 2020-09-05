// import 'dart:async';

import 'dart:math';
import 'package:flutter/material.dart';

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
            borderRadius: BorderRadius.circular(20.0),
          ),
          insetPadding: EdgeInsets.fromLTRB(40, 160, 40, 160),
          // backgroundColor: Colors.transparent,
          // type: MaterialType.canvas,
          child: Center(
              child: Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
                      Text(
                        'Looney Cam Instructions',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: 'FredokaOne',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Transform.rotate(
                            angle: 90 * pi / 180,
                            child: Icon(
                              Icons.settings_ethernet,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              'Sweap to change Looney set',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 20,
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
                                fontSize: 20,
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
                                fontSize: 20,
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
                              'Pinch to change your Looney Element size',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 20,
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
                            Icons.fingerprint,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Flexible(
                            child: Text(
                              'Tap any other Looney element to replace the current one',
                              style: TextStyle(
                                fontFamily: 'HelveticaNeue',
                                color: Color(0xffffffff),
                                fontSize: 20,
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

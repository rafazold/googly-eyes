import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/getImage.dart';

class Home extends StatelessWidget {
  final SelectImage _image = SelectImage();

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SafeArea(
              child: AppBar(
                flexibleSpace: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/googly_icon.png',
                      fit: BoxFit.contain,
                      width: 60,
                      height: 60,
                    ),
                    SizedBox(width: 14),
                    Text(
                      'Googly Eyes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontFamily: 'FredokaOne',
                      ),
                    ),
                  ],
                ),
                elevation: 0.0,
                backgroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment(-0.74, 0.91),
            end: Alignment(0.9, -1.07),
            colors: [Color(0xffff0077), Color(0xffff724e)],
            stops: [0.0, 1.0],
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(child: Container(), flex: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 100,
                  ),
                ),
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Image.asset('assets/gallery_icon.png'),
                        iconSize: 105,
                        onPressed: () {
                          print('add to gallery presed');
                          _image.getImage().then((img) {
                            Navigator.pushNamed(context, '/image',
                                arguments: {'imgFile': img});
                          });
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Add from Gallery',
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: 'HelveticaNeue',
                            fontSize: 20,
                            letterSpacing: 0.666),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    height: 100,
                  ),
                ),
                Container(
                  height: 200,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Image.asset('assets/camera_icon.png'),
                        iconSize: 105,
                        onPressed: () {
                          _image.getPicture().then((img) {
                            Navigator.pushNamed(context, '/image',
                                arguments: {'imgFile': img});
                          });
                          print('take a picture presed');
                          print(_image.getPicture());
                        },
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Take a Picture',
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: 'HelveticaNeue',
                            fontSize: 20,
                            letterSpacing: 0.666),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 100,
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Container(
                height: 100,
              ),
            ),
            Text('Pick your choice',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontFamily: 'HelveticaNeue',
                    fontWeight: FontWeight.w100)),
            Expanded(
              flex: 1,
              child: Container(
                height: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

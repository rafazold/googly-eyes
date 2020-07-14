import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffffffff),
      body: Stack(
        children: <Widget>[
          // Adobe XD layer: 'Background' (shape)
          Container(
            width: 415.0,
            height: 812.0,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.74, 0.91),
                end: Alignment(0.9, -1.07),
                colors: [const Color(0xffff0077), const Color(0xffff724e)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Adobe XD layer: 'Eye' (group)
          Stack(
            children: <Widget>[
              Transform.translate(
                offset: Offset(74.0, 240.0),
                child: Text(
                  'googly eyes',
                  style: TextStyle(
                    fontFamily: 'Fredoka One',
                    fontSize: 40,
                    color: const Color(0x00242323),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Transform.translate(
                offset: Offset(243.0, 299.0),
                child: Container(
                  width: 33.0,
                  height: 34.0,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.elliptical(16.5, 17.0)),
                    color: const Color(0xffffffff),
                  ),
                ),
              ),
              Transform.translate(
                offset: Offset(105.52, 327.61),
                child: SvgPicture.string(
                  _svg_w9h1sg,
                  allowDrawingOutsideViewBox: true,
                ),
              ),
              Transform.translate(
                offset: Offset(105.52, 327.61),
                child: Stack(
                  children: <Widget>[
                    Transform.translate(
                      offset: Offset(23.68, 8.2),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            width: 107.6,
                            height: 107.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                  Radius.elliptical(53.82, 53.82)),
                              color: const Color(0xff0a9dff),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(5.38, 46.05),
                            child: SvgPicture.string(
                              _svg_55izw8,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                          Transform(
                            transform: Matrix4(
                                0.23179,
                                -0.972766,
                                0.0,
                                0.0,
                                0.972766,
                                0.23179,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                1.0,
                                0.0,
                                6.56,
                                82.89,
                                0.0,
                                1.0),
                            child: Container(
                              width: 78.5,
                              height: 78.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                    Radius.elliptical(39.24, 39.24)),
                                color: const Color(0xff242323),
                              ),
                            ),
                          ),
                          Transform.translate(
                            offset: Offset(66.03, 32.47),
                            child: SvgPicture.string(
                              _svg_s40jpm,
                              allowDrawingOutsideViewBox: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SvgPicture.string(
                      _svg_r2o3x2,
                      allowDrawingOutsideViewBox: true,
                    ),
                  ],
                ),
              ),
              Transform.translate(
                offset: Offset(168.0, 358.71),
                // child: SvgPicture.string(
                //   _svg_yie005,
                //   allowDrawingOutsideViewBox: true,
                // ),
              ),
            ],
          ),
          Transform.translate(
            offset: Offset(0.0, 806.0),
            child:
                // Adobe XD layer: 'Rectangle 19' (shape)
                Container(
              width: 375.0,
              height: 6.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.74, 0.91),
                  end: Alignment(0.9, -1.07),
                  colors: [const Color(0xffff0077), const Color(0xffff724e)],
                  stops: [0.0, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _svg_55izw8 =
    '<svg viewBox="5.4 46.0 96.9 56.2" ><path transform="translate(-163.33, -355.9)" d="M 265.5953063964844 409.7182922363281 C 265.5953063964844 436.4712829589844 243.9067993164063 458.1579284667969 217.1556701660156 458.1579284667969 C 190.4026184082031 458.1579284667969 168.7160034179688 436.4712829589844 168.7160034179688 409.7182922363281 C 168.7160034179688 382.9652404785156 190.4026184082031 433.8473205566406 217.1556701660156 433.8473205566406 C 243.9067993164063 433.8473205566406 265.5953063964844 382.9652404785156 265.5953063964844 409.7182922363281 Z" fill="#00ffff" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.4" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_s40jpm =
    '<svg viewBox="66.0 32.5 11.9 11.9" ><path transform="translate(-134.44, -362.36)" d="M 212.3361358642578 400.7654418945313 C 212.3361358642578 404.0407104492188 209.6816558837891 406.6970825195313 206.4065093994141 406.6970825195313 C 203.1294708251953 406.6970825195313 200.4750213623047 404.0407104492188 200.4750213623047 400.7654418945313 C 200.4750213623047 397.4903564453125 203.1294708251953 394.8340454101563 206.4065093994141 394.8340454101563 C 209.6816558837891 394.8340454101563 212.3361358642578 397.4903564453125 212.3361358642578 400.7654418945313 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_r2o3x2 =
    '<svg viewBox="0.0 0.0 155.0 118.7" ><path transform="translate(-153.5, -355.93)" d="M 308.50390625 433.4345092773438 C 308.50390625 476.2385864257813 273.8045654296875 474.653564453125 231.0004272460938 474.653564453125 C 188.1963806152344 474.653564453125 153.4970092773438 476.2385864257813 153.4970092773438 433.4345092773438 C 153.4970092773438 390.63037109375 188.1963806152344 355.9309692382813 231.0004272460938 355.9309692382813 C 273.8045654296875 355.9309692382813 308.50390625 390.63037109375 308.50390625 433.4345092773438 Z" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
const String _svg_w9h1sg =
    '<svg viewBox="105.5 327.6 155.0 118.7" ><path transform="translate(-47.98, -28.32)" d="M 308.50390625 433.4345092773438 C 308.50390625 476.2385864257813 273.8045654296875 474.653564453125 231.0004272460938 474.653564453125 C 188.1963806152344 474.653564453125 153.4970092773438 476.2385864257813 153.4970092773438 433.4345092773438 C 153.4970092773438 390.63037109375 188.1963806152344 355.9309692382813 231.0004272460938 355.9309692382813 C 273.8045654296875 355.9309692382813 308.50390625 390.63037109375 308.50390625 433.4345092773438 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';

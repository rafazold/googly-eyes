// import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/eyesCard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
// import ‘package:vector_math/vector_math_64.dart’ as vector;

class MakeImage extends StatefulWidget {
  @override
  _MakeImageState createState() => _MakeImageState();
}

class _MakeImageState extends State<MakeImage> {
  ScrollController _controller = new ScrollController();
  ScreenshotController screenshotController = ScreenshotController();
  String _assetsPath;
  double eyesPosX = 200.0;
  double eyesPosy = 200.0;
  String eyesImg = 'assets/eyes/initial/group_84.png';
  double eyesScale = 1.6;
  double eyesBaseSize = 1.6;
  double eyesLastSize;
  bool showEyes = false;
  File _imageFile;
  // Map droppedEyes = {
  //   'xPos': 0,
  //   'yPos': 0,
  //   'img': 'assets/eyes/initial/group_84.png',
  // };
  List someImages;
  @override
  void initState() {
    getEyes().then((path) => setState(() {
          _assetsPath = path;
        }));
    _initImages('initial');
    super.initState();
  }

  Future _initImages(String batch) async {
    // >> To get paths you need these 2 lines
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('eyes/$batch'))
        .where((String key) => key.contains('.png') || key.contains('.gif'))
        .toList();

    setState(() {
      someImages = imagePaths;
    });
  }

  Future<String> getEyes() async {
    print('#############################################');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    print('yoooooo: $appDocPath');
    return appDocPath;
  }

  Future<File> setStaticImage() {
    _imageFile = null;
    return screenshotController
        .capture(delay: Duration(milliseconds: 10))
        .then((File image) {
      print('Capture Done: ${image.path}');
      setState(() {
        _imageFile = image;
      });
      return image;
    }).catchError((onError) {
      print(onError);
    });
  }

  Future<File> setAnimatedImage() {}

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        // centerTitle: true,
        title: RawMaterialButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Stack(
            alignment: AlignmentDirectional.center,
            children: <Widget>[
              Opacity(
                opacity: 0.25999999046325684,
                child: Container(
                    width: 67.0,
                    height: 30.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(21))),
              ),
              Text('Back'),
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(width: 20),
          RawMaterialButton(
            onPressed: () {
              print('done pressed');
              setStaticImage().then((imgFile) => {
                    Navigator.pushNamed(context, '/voice',
                        arguments: {'imgFile': imgFile})
                  });
            },
            // onPressed: () {
            //   print('done pressed');
            //   _imageFile = null;
            //   screenshotController
            //       .capture(delay: Duration(milliseconds: 10))
            //       .then((File image) async {
            //     print('Capture Done: ${image.path}');
            //     setState(() {
            //       _imageFile = image;
            //     });
            //     Navigator.pushNamed(context, '/voice',
            //         arguments: {'imgFile': image});
            //   }).catchError((onError) {
            //     print(onError);
            //   });
            // },
            child: Container(
              width: 89,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  gradient: LinearGradient(
                    colors: [Color(0xffff0775), Color(0xfffc6c4e)],
                    stops: [0, 1],
                    begin: Alignment(-0.98, 0.19),
                    end: Alignment(0.98, -0.19),
                    // angle: 79,
                    // scale: undefined,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(width: 20),
                  Icon(Icons.done),
                  Text('Done'),
                  // SizedBox(width: 20),
                ],
              ),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: DragTarget<String>(
                onWillAccept: (d) {
                  print("on will accept");
                  return true;
                },
                onAccept: (d) {
                  setState(() {
                    showEyes = true;
                    eyesImg = d;
                  });
                  print("ACCEPT 2!: $d");
                  print(arguments['imgFile'].path);
                },
                onLeave: (d) {
                  print("LEAVE 2!");
                },
                builder: (context, list, list2) {
                  return GestureDetector(
                    onScaleStart: (details) {
                      print('scale details::::: ----- $details');
                    },
                    onScaleUpdate: (details) {
                      double scaleValue =
                          num.parse(details.scale.toStringAsFixed(2));
                      int rounded = (scaleValue * 100).toInt();

                      if (rounded.isEven) {
                        // print('UPDATE!!!! $scaleValue}');
                        setState(() {
                          eyesScale = (eyesBaseSize * scaleValue).clamp(0.3, 5);
                        });
                      }
                    },
                    onScaleEnd: (details) {
                      print('FINISHED!!! ------->>>> $details');
                      eyesBaseSize = eyesScale;
                    },
                    child: Screenshot(
                      controller: screenshotController,
                      child: Stack(children: [
                        arguments['imgFile'] != null
                            ? Center(
                                child: OverflowBox(
                                    minWidth: 0.0,
                                    minHeight: 0.0,
                                    maxHeight: double.infinity,
                                    child: Image.file(
                                        File(arguments['imgFile'].path))))
                            : Text('No image selected'),
                        !showEyes
                            ? Text('')
                            : Positioned(
                                top: eyesPosy,
                                left: eyesPosX,
                                // height: 38,
                                // width: 80,
                                child: Draggable<String>(
                                  onDragStarted: () => print("DRAG START!"),
                                  onDragCompleted: () =>
                                      print("DRAG COMPLETED!"),
                                  onDragEnd: (details) {
                                    setState(() {
                                      eyesPosX =
                                          details.offset.dx.clamp(-30, 300);
                                      eyesPosy =
                                          details.offset.dy.clamp(-30, 700);
                                    });
                                    print(
                                        'details::::::::::::::::::::::::::::::::   ${details.offset} - direction: ${details.offset.direction} - x: ${details.offset.dx} - y: ${details.offset.dy} POSx: $eyesPosX POSy: $eyesPosy');
                                  },
                                  feedback: Transform(
                                      transform: Matrix4.diagonal3(
                                          vector.Vector3(
                                              eyesScale, eyesScale, eyesScale)),
                                      alignment: FractionalOffset.center,
                                      child: Image.asset(eyesImg)),
                                  // Image.asset(eyesImg, scale: eyesScale),
                                  // child: ZoomableImage(AssetImage(eyesImg)),
                                  child: Transform(
                                      transform: Matrix4.diagonal3(
                                          vector.Vector3(
                                              eyesScale, eyesScale, eyesScale)),
                                      alignment: FractionalOffset.center,
                                      child: Image.asset(eyesImg)),
                                  data: eyesImg,
                                  childWhenDragging: Container(),
                                ),
                              )
                      ]),
                    ),
                  );
                },
                // onAccept: (data) => print('data'),
              ),
              flex: 7,
            ),
            Expanded(
              child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xffff0077), Color(0xffff724e)],
                      stops: [0, 1],
                      begin: Alignment(-0.93, 0.36),
                      end: Alignment(0.93, -0.36),
                      // angle: 69,
                      // scale: undefined,
                    ),
                  ),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(), // new
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: someImages.length,
                    itemBuilder: (context, index) {
                      return EyesCard(
                          index: index,
                          onPress: () {},
                          imagePath: someImages[index]);
                    },
                  )),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}

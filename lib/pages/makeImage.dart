import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/getImage.dart';
import 'package:googly_eyes/utilities/eyesCard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
// import 'package:zoomable_image/zoomable_image.dart';

class MakeImage extends StatefulWidget {
  @override
  _MakeImageState createState() => _MakeImageState();
}

class _MakeImageState extends State<MakeImage> {
  ScrollController _controller = new ScrollController();
  String _assetsPath;
  double eyesPosX = 100.0;
  double eyesPosy = 200.0;
  String eyesImg = 'assets/eyes/initial/group_84.png';
  bool showEyes = false;
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
        .where((String key) => key.contains('.png'))
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

  Future printPath() async {
    // _initImages('initial')
    //     .then((value) => someImages.forEach((element) => print(element)));
    print('');
  }

  @override
  Widget build(BuildContext context) {
    bool succesfulDrop;
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: FlatButton(onPressed: printPath, child: Text('get Eyes')),
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
                  return Stack(children: [
                    arguments['imgFile'] != null
                        ? Image.asset(arguments['imgFile'].path)
                        : Text('No image selected'),
                    !showEyes
                        ? Text('')
                        : Positioned(
                            top: eyesPosy,
                            left: eyesPosX,
                            // height: 38,
                            // width: 80,
                            child: LongPressDraggable<String>(
                              onDragStarted: () => print("DRAG START!"),
                              onDragCompleted: () => print("DRAG COMPLETED!"),
                              onDragEnd: (details) {
                                setState(() {
                                  eyesPosX = details.offset.dx;
                                  eyesPosy = details.offset.dy - 80;
                                });
                                print(
                                    'details::::::::::::::::::::::::::::::::   ${details.offset} - direction: ${details.offset.direction} - x: ${details.offset.dx} - y: ${details.offset.dy}');
                              },
                              feedback: Image.asset(eyesImg),
                              // child: ZoomableImage(AssetImage(eyesImg)),
                              child: Image.asset(eyesImg),
                              data: eyesImg,
                              childWhenDragging: Container(),
                            ),
                          )
                  ]);
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

// ConstrainedBox(
//         constraints: BoxConstraints.tightFor(height: max(500, constraints.maxHeight)),
//         child: Column(),

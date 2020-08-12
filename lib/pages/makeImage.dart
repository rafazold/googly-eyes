import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/eyesCard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class MakeImage extends StatefulWidget {
  @override
  _MakeImageState createState() => _MakeImageState();
}

class _MakeImageState extends State<MakeImage> {
  ScrollController _controller = new ScrollController();
  ScreenshotController screenshotController = ScreenshotController();

  double eyesPosX = 200.0;
  double eyesPosy = 200.0;
  String eyesImg = 'assets/eyes/initial/group_84.png';
  double eyesScale = 1.0;
  double eyesBaseSize = 1.0;
  double eyesLastSize;
  bool showEyes = false;
  bool loading = false;
  List someImages = [];
  List imagesLists = ['eyes', 'mouth', 'face'];
  int currentList = 0;
  @override
  void initState() {
    _initImages(imagesLists[currentList]);
    super.initState();
  }

  Future _initImages(String batch) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final keysList = manifestMap.keys
        .where((String key) => key.contains('eyes/initial/$batch'));
    print(
        '=> => => => => => => => => => => => $keysList => => => => => => => => => => => => ');

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('eyes/initial/$batch'))
        .where((String key) => key.contains('.png') || key.contains('.gif'))
        .toList();

    setState(() {
      someImages = imagePaths;
      loading = false;
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
    return screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 3)
        .then((File image) {
      print('Capture Done: ${image.path}');
      setState(() {});
      return image;
    }).catchError((onError) {
      print(onError);
    });
  }

  void _setInitialEyesPosition(Map eyesPosition) {
    setState(() {
      eyesPosX = eyesPosition['offsetX'];
      eyesPosy = eyesPosition['offsetY'];
    });
  }

  void _resetEyes() {
    setState(() {
      showEyes = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return loading
        ? Container()
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
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
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.done),
                        Text('Done'),
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
                    flex: 7,
                    child: Container(
                      child: GestureDetector(
                          onScaleStart: (details) {
                            print('scale details::::: ----- $details');
                          },
                          onScaleUpdate: (details) {
                            double scaleValue =
                                num.parse(details.scale.toStringAsFixed(2));
                            int rounded = (scaleValue * 100).toInt();

                            if (rounded.isEven) {
                              setState(() {
                                eyesScale =
                                    (eyesBaseSize * scaleValue).clamp(0.3, 5);
                              });
                            }
                          },
                          onScaleEnd: (details) {
                            print('FINISHED!!! ------->>>> $details');
                            eyesBaseSize = eyesScale;
                          },
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
                              return Screenshot(
                                controller: screenshotController,
                                child: Stack(children: [
                                  arguments['imgFile'] != null
                                      ? Center(
                                          child: OverflowBox(
                                              minWidth: 0.0,
                                              minHeight: 0.0,
                                              maxHeight: double.infinity,
                                              child: Image.file(File(
                                                  arguments['imgFile'].path))))
                                      : Text('No image selected'),
                                  !showEyes
                                      ? Text('')
                                      // TODO: to add more eyes, instead of this child it
                                      : Positioned(
                                          top: eyesPosy,
                                          left: eyesPosX,
                                          child: Draggable<String>(
                                            onDragEnd: (details) {
                                              setState(() {
                                                eyesPosX = details.offset
                                                    .dx; //.clamp(-30, 300);
                                                eyesPosy = details.offset
                                                    .dy; //.clamp(-30, 700);
                                              });
                                            },
                                            feedback: Transform(
                                                transform: Matrix4.diagonal3(
                                                    vector.Vector3(eyesScale,
                                                        eyesScale, eyesScale)),
                                                alignment:
                                                    FractionalOffset.center,
                                                child: Image.asset(
                                                  eyesImg,
                                                  width: 200,
                                                )),
                                            child: Transform(
                                                transform: Matrix4.diagonal3(
                                                    vector.Vector3(eyesScale,
                                                        eyesScale, eyesScale)),
                                                alignment:
                                                    FractionalOffset.center,
                                                child: Image.asset(
                                                  eyesImg,
                                                  width: 200,
                                                )),
                                            data: eyesImg,
                                            childWhenDragging: Container(),
                                          ),
                                        )
                                ]),
                              );
                            },
                          )),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onVerticalDragEnd: (details) {
                        if (details.primaryVelocity > 0 &&
                            currentList - 1 >= 0) {
                          setState(() {
                            currentList--;
                          });
                        } else if (details.primaryVelocity < 0 &&
                            currentList + 1 < imagesLists.length) {
                          setState(() {
                            currentList++;
                          });
                        }
                        _initImages(imagesLists[currentList]);

                        print(
                            '${details.primaryVelocity}, - {direction(details.primaryVelocity)} $currentList');
                      },
                      child: DragTarget(
                        builder: (context, list, list2) {
                          return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xffff0077),
                                    Color(0xffff724e)
                                  ],
                                  stops: [0, 1],
                                  begin: Alignment(-0.93, 0.36),
                                  end: Alignment(0.93, -0.36),
                                ),
                              ),
                              // TODO: try with Silverlist or SilverGrid to use one big list
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                controller: _controller,
                                scrollDirection: Axis.horizontal,
                                itemCount: someImages.length,
                                itemBuilder: (context, index) {
                                  return EyesCard(
                                    index: index,
                                    onPress: () {
                                      setState(() {
                                        eyesImg = someImages[index];
                                      });
                                      // print(someImages[index]);
                                    },
                                    imagePath: someImages[index],
                                    eyesPossition: _setInitialEyesPosition,
                                  );
                                },
                              ));
                        },
                      ),
                    ),
                    flex: 1,
                  )
                ],
              ),
            ),
          );
  }
}

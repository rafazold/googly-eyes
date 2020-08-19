import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/handleImage.dart';
import 'package:googly_eyes/widgets/eyesToolbar.dart';
import 'package:googly_eyes/widgets/recordToolbar.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/services.dart';
// import 'package:googly_eyes/';

// import 'package:path/path.dart';

class MakeImage extends StatefulWidget {
  @override
  _MakeImageState createState() => _MakeImageState();
}

class _MakeImageState extends State<MakeImage> {
  // ScrollController _controller = new ScrollController();
  ScreenshotController screenshotController = ScreenshotController();
  GlobalKey imageKey = GlobalKey();
  GlobalKey eyes1 = GlobalKey();

  double eyesPosX = 200.0;
  double eyesPosy = 200.0;
  String eyesImg = 'assets/eyes/initial/group_84.png';
  double eyesScale = 1.0;
  double eyesBaseSize = 1.0;
  double eyesLastSize;
  bool showEyes = false;
  bool loading = false;
  List someImages = [];
  List imagesLists = ['eyes', 'mouth', 'face', 'animation'];
  int currentList = 0;
  bool isAnimated = false;
  String tempDirPath;
  bool hideAppBar = false;
  bool showVideoToolbar = false;
  String assetsDirectory;
  String tempAnimatedImgOut;

  final HandleImage handleImages = HandleImage();

  @override
  void initState() {
    _initImages(imagesLists[currentList]);
    _getTempDirPath();
    getAssetsDir();
    super.initState();
  }

  void _getTempDirPath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    setState(() {
      tempDirPath = tempPath;
    });
  }

  Future _initImages(String batch) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('eyes/initial/$batch'))
        .where((String key) => key.contains('.png') || key.contains('.gif'))
        .toList();

    setState(() {
      someImages = imagePaths;
      loading = false;
    });
  }

  void getAssetsDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    print('paaaaaath' + appDocPath);
    setState(() {
      assetsDirectory = appDocPath;
    });
  }

  Future<File> setStaticImage() {
    return screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 3)
        .then((File image) {
      print('Capture Done: ${image.path}');
      setState(() {});
      return image;
    }).catchError((onError) {
      print('onError');
    });
  }

  void _setInitialEyesPosition(Map eyesPosition) {
    setState(() {
      eyesPosX = eyesPosition['offsetX'];
      eyesPosy = eyesPosition['offsetY'];
    });
  }

  void _updateEyesImg(String imagePath) {
    setState(() {
      eyesImg = imagePath;
    });
  }

  // assetsDirectory/$eyesImg
  Future<File> copyFileAssets(String assetName, String localName) async {
    final ByteData assetByteData = await rootBundle.load(assetName);

    final List<int> byteList = assetByteData.buffer
        .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

    final String fullTemporaryPath = tempDirPath + localName;
    setState(() {
      tempAnimatedImgOut = fullTemporaryPath;
    });
    return File(fullTemporaryPath)
        .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;

    return loading
        ? Container()
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: hideAppBar
                ? null
                : AppBar(
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
                          setStaticImage().then((imgFile) => {
                                Navigator.pushNamed(context, '/voice',
                                    arguments: {
                                      'imgFile': imgFile,
                                      'vidFiles': [],
                                      'eyesPosX': eyesPosX,
                                      'eyesPosY': eyesPosy,
                                      'bgPath': arguments['imgFile'].path,
                                      'eyesPath': eyesImg
                                    })
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
                      FlatButton(
                          onPressed: () {
                            RenderBox box =
                                imageKey.currentContext.findRenderObject();
                            Offset position = box.localToGlobal(Offset.zero);
                            double xOffset = position.dx;
                            double yOffset = position.dy;
                            double width = box.size.width;
                            double height = box.size.height;
                            RenderBox eyes =
                                eyes1.currentContext.findRenderObject();
                            Offset pos = eyes.localToGlobal(Offset.zero);
                            double xOff = pos.dx;
                            double yOff = pos.dy;
                            double wid = eyes.size.width * eyesScale;
                            double hei = eyes.size.height * eyesScale;
                            print(
                                'x: $xOffset - y: $yOffset - width: $width - height: $height == x: $xOff == y: $yOff == w: $wid == h: $hei == scale: $eyesScale');
                            print('$assetsDirectory/$eyesImg');
                            // copyFileAssets(
                            //     arguments['imgFile'].path, '/animated.gif');
                            handleImages
                                .copyAnimationFromAssetsToTemp(
                                    eyesImg, '/animated.png')
                                .then((animatedEyesPath) {
                              setStaticImage().then((imgFile) => {
                                    Navigator.pushNamed(context, '/voice',
                                        arguments: {
                                          'imgFile': imgFile,
                                          'eyesPosX': xOff,
                                          'eyesPosY': yOff,
                                          'eyesPath': animatedEyesPath,
                                          'bgPosX': xOffset,
                                          'bgPosY': yOffset,
                                          'bgPath': arguments['imgFile'].path,
                                          'bgW': width,
                                          'bgH': height,
                                          'eyW': wid,
                                          'eyH': hei,
                                          'vidFiles': [eyesImg],
                                          'xOff': xOff - xOffset,
                                          'yOff': yOff - yOffset
                                        })
                                  });
                            });
                          },
                          child: Text('try me'))
                    ],
                  ),
            body: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    flex: 64,
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
                                              child: Container(
                                                key: imageKey,
                                                child: Image.file(File(
                                                    arguments['imgFile'].path)),
                                              )))
                                      : Text('No image selected'),
                                  !showEyes
                                      ? Text('')
                                      // TODO: to add more eyes, instead of this child it needs to be a Stack with childred [positioned, positioned, positioned]
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
                                                  key: eyes1,
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
                    child: showVideoToolbar
                        ? RecordToolbar()
                        : EyesToolbar(
                            eyesPossition: _setInitialEyesPosition,
                            updateEyesImg: _updateEyesImg),
                    flex: 10,
                  )
                ],
              ),
            ),
          );
  }
}

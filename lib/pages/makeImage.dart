import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:googly_eyes/utilities/handleImage.dart';
import 'package:googly_eyes/widgets/eyesToolbar.dart';
import 'package:googly_eyes/widgets/pinkButton.dart';
import 'package:googly_eyes/widgets/prevButton.dart';
import 'package:googly_eyes/widgets/recordToolbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:vector_math/vector_math_64.dart' as vector;
import 'package:flutter/services.dart';

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
  // List cardsImages = [];
  List imagesLists = ['eyes', 'mouth', 'face', 'animation'];
  int currentList = 0;
  bool isAnimated = false;
  String tempDirPath;
  bool hideAppBar = false;
  bool showRecordToolbar = false;
  String assetsDirectory;
  String tempAnimatedImgOut;

  final HandleImage handleImages = HandleImage();

  @override
  void initState() {
    // _getImagesForCards(imagesLists[currentList]);
    getTempDirPath().then((path) {
      setState(() {
        tempDirPath = path;
      });
    });
    getAssetsDir().then((path) {
      setState(() {
        assetsDirectory = path;
      });
    });
    super.initState();
  }

//TODO: pass to external class
  Future getTempDirPath() async {
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    return tempPath;
  }

//TODO: pass to external class
  Future getAssetsDir() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;
    return appDocPath;
  }

//TODO: pass to external class
  Future<File> takeScreenshot() {
    return screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 3)
        .then((File image) => image)
        .catchError((onError) {
      print('onError');
    });
  }

  void _setInitialEyesPosition(Map eyesPosition) {
    // TODO: when making multiple, instance should have key position updated with method, also when moved needs to be updated.
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
  ////TODO: pass to external class (currently not used)
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

  void renderStatic(String bgPath) {
    takeScreenshot().then((imgFile) => {
          Navigator.pushNamed(context, '/voice', arguments: {
            'imgFile': imgFile,
            'vidFiles': [],
            'eyesPosX': eyesPosX,
            'eyesPosY': eyesPosy,
            'bgPath': bgPath,
            'eyesPath': eyesImg
          })
        });
  }

  void renderAnimation(String bgPath) {
    print('S T E P ================      1');
    RenderBox box = imageKey.currentContext.findRenderObject();
    Offset position = box.localToGlobal(Offset.zero);
    double xOffset = position.dx;
    double yOffset = position.dy;
    double width = box.size.width;
    double height = box.size.height;
    RenderBox eyes = eyes1.currentContext.findRenderObject();
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
        .copyAnimationFromAssetsToTemp(eyesImg, '/animated.png')
        .then((animatedEyesPath) {
      print('S T E P ================      2');
      takeScreenshot().then((imgFile) {
        // copyFileAssets(assetName, localName).then((imgFile) {
        print('S T E P ================      3');
        Navigator.pushNamed(context, '/voice', arguments: {
          'imgFile': imgFile,
          'eyesPosX': xOff,
          'eyesPosY': yOff,
          'eyesPath': animatedEyesPath,
          'bgPosX': xOffset,
          'bgPosY': yOffset,
          'bgPath': bgPath,
          'bgW': width,
          'bgH': height,
          'eyW': wid,
          'eyH': hei,
          'vidFiles': [eyesImg],
          'xOff': xOff - xOffset,
          'yOff': yOff - yOffset
        });
      });
    });
  }

  void handleDone(String bgPath, String overPath) {
    if (overPath.contains('animation')) {
      print('rendering A N I M A T E D: $overPath');
      renderAnimation(bgPath);
    } else {
      print('rendering S T A T I C: $overPath');
      renderStatic(bgPath);
    }
  }

  void handleEdit() {
    setState(() {
      showRecordToolbar = !showRecordToolbar;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final PickedFile bgFile = arguments['imgFile'];
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
                    title: PrevButton(),
                    actions: <Widget>[
                      SizedBox(width: 20),
                      PinkButton(
                        buttonText: ' Done',
                        icon: Icons.done,
                        callback: () {
                          handleDone(bgFile.path, eyesImg);
                        },
                      ),
                      SizedBox(width: 10),
                      PinkButton(
                        buttonText: ' Edit',
                        icon: Icons.edit,
                        callback: handleEdit,
                      ),
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
                            },
                            builder: (context, list, list2) {
                              return Screenshot(
                                controller: screenshotController,
                                child: Stack(children: [
                                  bgFile != null
                                      ? Center(
                                          child: OverflowBox(
                                              minWidth: 0.0,
                                              minHeight: 0.0,
                                              maxHeight: double.infinity,
                                              child: Container(
                                                key: imageKey,
                                                child: Image.file(
                                                    File(bgFile.path)),
                                              )))
                                      : Text('No image selected'),
                                  !showEyes
                                      ? Text('')
                                      // TODO: to add more eyes, instead of this child it needs to be a Stack with childred [positioned, positioned, positioned], each with its own key
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
                    child: showRecordToolbar
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

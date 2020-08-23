import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:googly_eyes/utilities/handleFile.dart';
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
  ScreenshotController screenshotController = ScreenshotController();
  final FlutterFFmpeg _flutterFFmpeg = FlutterFFmpeg();
  GlobalKey imageKey = GlobalKey();
  GlobalKey eyes1 = GlobalKey();

  double eyesPosX = 200.0;
  double eyesPosy = 200.0;
  String eyesImg = 'assets/eyes/initial/group_84.png';
  double eyesScale = 1.0;
  double eyesBaseSize = 1.0;
  double eyesLastSize;
  List imagesLists = ['eyes', 'mouth', 'face', 'animation'];
  int currentList = 0;
  String tempDirPath;
  String assetsDirectory;
  // String tempAnimatedImgOut;
  String audioPath;
  bool showEyes = false;
  bool loading = false;
  bool hideAppBar = false;
  bool isVideoAnimated = false;
  bool isAudioAnimated = false;
  bool editing = true;
  bool showRecordToolbar = false;
  Map finalDetails;
  String finalUrl;

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

  void _updateAudioPath(String path) {
    setState(() {
      audioPath = path;
      isAudioAnimated = true;
    });
  }

  // assetsDirectory/$eyesImg
  ////TODO: pass to external class (currently not used)
  // Future<File> copyFileAssets(String assetName, String localName) async {
  //   final ByteData assetByteData = await rootBundle.load(assetName);

  //   final List<int> byteList = assetByteData.buffer
  //       .asUint8List(assetByteData.offsetInBytes, assetByteData.lengthInBytes);

  //   final String fullTemporaryPath = tempDirPath + localName;
  //   setState(() {
  //     tempAnimatedImgOut = fullTemporaryPath;
  //   });
  //   return File(fullTemporaryPath)
  //       .writeAsBytes(byteList, mode: FileMode.writeOnly, flush: true);
  // }

  void renderStatic(String bgPath) {
    // RenderBox box = imageKey.currentContext.findRenderObject();
    takeScreenshot().then((imgFile) {
      decodeImageFromList(imgFile.readAsBytesSync()).then((asset) {
        print('renderedStatic');
        //TODO: set in state an instance of Googlyfied (type: audio/video/both/static, + details below)
        setState(() {
          finalDetails = {
            'type': 'static',
            'imgFile': imgFile,
            'vidFiles': [],
            'eyesPosX': eyesPosX,
            'eyesPosY': eyesPosy,
            'bgPath': bgPath,
            'eyesPath': eyesImg,
            'bgW': asset.width,
            'bgH': asset.height
          };
        });
      }).then((_) {
        print('static rendered with details: $finalDetails');
      });
      // Navigator.pushNamed(context, '/voice', arguments: {
      //   'imgFile': imgFile,
      //   'vidFiles': [],
      //   'eyesPosX': eyesPosX,
      //   'eyesPosY': eyesPosy,
      //   'bgPath': bgPath,
      //   'eyesPath': eyesImg
      // })
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
    //TODO: check if image is rendered in the session and if so pass the path rather than prepare the assets again.
    handleImages
        .copyAnimationFromAssetsToTemp(eyesImg, '/animated.png')
        .then((animatedEyesPath) {
      print('S T E P ================      2');
      takeScreenshot().then((imgFile) {
        // copyFileAssets(assetName, localName).then((imgFile) {
        print('S T E P ================      3');
        //TODO: set in state an instance of Googlyfied (type: audio/video/both/static, + details below)
        setState(() {
          finalDetails = {
            'type': 'animated',
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
          };
        });
        // Navigator.pushNamed(context, '/voice', arguments: {
        //   'imgFile': imgFile,
        //   'eyesPosX': xOff,
        //   'eyesPosY': yOff,
        //   'eyesPath': animatedEyesPath,
        //   'bgPosX': xOffset,
        //   'bgPosY': yOffset,
        //   'bgPath': bgPath,
        //   'bgW': width,
        //   'bgH': height,
        //   'eyW': wid,
        //   'eyH': hei,
        //   'vidFiles': [eyesImg],
        //   'xOff': xOff - xOffset,
        //   'yOff': yOff - yOffset
        // });
      });
    });
  }

  void handleDone(String bgPath, String overlayPath) {
    if (!editing) {
      return;
    }
    setState(() {
      editing = false;
      showRecordToolbar = true;
    });
    if (overlayPath.contains('animation')) {
      setState(() {
        isVideoAnimated = true;
      });
      print('rendering A N I M A T E D: $overlayPath');
      renderAnimation(bgPath);
    } else {
      setState(() {
        isVideoAnimated = false;
      });
      print('rendering S T A T I C: $overlayPath');
      renderStatic(bgPath);
    }
  }

  void handleEdit() {
    print('edit');
    setState(() {
      editing = true;
      showRecordToolbar = false;
    });
  }

  // TODO: move to another class
  int makeIntEven(intOrDouble) {
    int number = intOrDouble.toInt();
    if (number.runtimeType == double) {
      number.toInt();
    }
    if (number.isEven) {
      return number;
    } else {
      return number - 1;
    }
  }

  // TODO: move to another class
  int makeMax(int number) {
    if (number <= 1226) {
      return number;
    } else {
      return 1226;
    }
  }

  Future<int> renderFinal(String type) async {
    List<String> arguments;
    String timeStamp = (new DateTime.now().millisecondsSinceEpoch).toString();
    String videoUrl = '$tempDirPath/googly_video-$timeStamp.mp4';
    String gifUrl = '$tempDirPath/googly_video-$timeStamp.gif';
    print('will make $type and details: $finalDetails');
    if (type == 'static') {
      setState(() {
        finalUrl = finalDetails['imgFile'].path;
      });
      return 0;
    } else if (type == 'audioStatic') {
      arguments = [
        "-i",
        "${finalDetails['imgFile'].path}",
        "-i",
        "$audioPath",
        "-loop",
        "1",
        "-c:v",
        "libx264",
        "-t",
        "15",
        "-pix_fmt",
        "yuv420p",
        "-vf",
        // "-vsync 0",
        "scale=${makeMax(makeIntEven(finalDetails['bgW']))}:-2",
        "$videoUrl"
      ];
      // TODO: fix scale & quality, compare with old addVoice
      setState(() {
        finalUrl = videoUrl;
      });
    } else if (type == 'animated') {
      arguments = [
        "-i",
        "${finalDetails['imgFile'].path}",
        "-stream_loop",
        "-1",
        "-r",
        "25",
        "-i",
        "${finalDetails['eyesPath']}",
        "-filter_complex",
        "[0]scale=w=${makeIntEven(finalDetails['bgW'])}:h=${makeIntEven(finalDetails['bgH'])}[bg], [1]fps=25[fps],[fps]scale=w=${makeIntEven(finalDetails['eyW'])}:h=${makeIntEven(finalDetails['eyH'])}[scaled],[scaled]palettegen[palettegen], [palettegen]paletteuse[eyes], [bg][eyes]overlay=${finalDetails['xOff']}:${finalDetails['yOff']}",
        // TODO: if landscape does not solve it (need to implement yet), try passing if portrait or landscape and according to that transpose.
        // "[0]transpose=dir=1:passthrough=portrait[bgTranspose], [bgTranspose]scale=w=${makeIntEven(bgW)}:h=${makeIntEven(bgH)}[bg], [1]fps=25[fps],[fps]scale=w=${makeIntEven(eyW)}:h=${makeIntEven(eyH)}[eyes], [bg][eyes]overlay=$xOff:$yOff",
        // "-c:v",
        // "libx264",
        "-t",
        "5",
        // "-pix_fmt",
        // "yuv420p",
        // "-preset",
        // "veryslow",
        // "-crf",
        // "17",
        // "-shortest",
        "$gifUrl"
      ];
      setState(() {
        finalUrl = gifUrl;
      });
    } else {
      arguments = [
        "-i",
        "${finalDetails['imgFile'].path}",
        "-stream_loop",
        "-1",
        "-r",
        "25",
        "-i",
        "${finalDetails['eyesPath']}",
        "-filter_complex",
        "[0]scale=w=${makeIntEven(finalDetails['bgW'])}:h=${makeIntEven(finalDetails['bgH'])}[bg], [1]fps=25[fps],[fps]scale=w=${makeIntEven(finalDetails['eyW'])}:h=${makeIntEven(finalDetails['eyH'])}[eyes], [bg][eyes]overlay=${finalDetails['xOff']}:${finalDetails['yOff']}",
        // TODO: if landscape does not solve it (need to implement yet), try passing if portrait or landscape and according to that transpose.
        // "[0]transpose=dir=1:passthrough=portrait[bgTranspose], [bgTranspose]scale=w=${makeIntEven(bgW)}:h=${makeIntEven(bgH)}[bg], [1]fps=25[fps],[fps]scale=w=${makeIntEven(eyW)}:h=${makeIntEven(eyH)}[eyes], [bg][eyes]overlay=$xOff:$yOff",
        "-i",
        "$audioPath",
        "-c:v",
        "libx264",
        "-t",
        "15",
        "-pix_fmt",
        "yuv420p",
        "-preset",
        "veryslow",
        "-crf",
        "17",
        "-shortest",
        "$videoUrl"
      ];
      setState(() {
        finalUrl = videoUrl;
      });
    }
    print('arguments: $arguments');
    int render =
        await _flutterFFmpeg.executeWithArguments(arguments).then((rc) {
      print('ffmpeg completed with response :::::::::::: $rc');
      return rc;
    }).catchError((e) {
      print('E R R O R :     $e');
    });
    return render;
  }

  void handleFinish() {
    if (!isVideoAnimated && !isAudioAnimated) {
      print('finished with type static');
      renderFinal('static').then((_) {
        Navigator.pushNamed(context, '/result',
            arguments: {'resultUrl': finalUrl, 'isVideo': false});
      });
    } else if (!isVideoAnimated && isAudioAnimated) {
      renderFinal('audioStatic').then((res) {
        print('finished with type audiostatic: res: $res');
        if (res == 0) {
          Navigator.pushNamed(context, '/result', arguments: {
            'resultUrl': finalUrl,
            'isVideo': true,
            'videoUrl': finalUrl,
            'videoFile': File(finalUrl),
            'width': makeMax(makeIntEven(finalDetails['bgW'])),
            'height': makeIntEven(finalDetails['bgH'])
          });
        }
      });
    } else if (isVideoAnimated && !isAudioAnimated) {
      renderFinal('animated').then((_) {
        print('finished with type animated');
      });
      // Navigator.pushNamed(context, '/result',
      //     arguments: {'resultUrl': finalUrl, 'isVideo': false});
    } else if (isVideoAnimated && isAudioAnimated) {
      renderFinal('audioAnimated').then((_) {
        print('finished with type audioAnimated');
      });
      // Navigator.pushNamed(context, '/result',
      //     arguments: {'resultUrl': finalUrl, 'isVideo': true});
    }

    // Navigator.pushNamed(context, '/share', arguments: passArguments);

    print('FINISH: audioUrl: $audioPath, overlayUrl: $eyesImg');
    // TODO: make ffmpeg magic, pass to new page for sending
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
                      editing
                          ? PinkButton(
                              buttonText: ' Done',
                              icon: Icons.done,
                              callback: () {
                                handleDone(bgFile.path, eyesImg);
                              },
                            )
                          : PinkButton(
                              buttonText: ' Finish',
                              icon: Icons.done,
                              callback: handleFinish),
                      SizedBox(width: 10),
                      editing
                          ? Container()
                          : PinkButton(
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
                                      ? Container()
                                      // TODO: to add more eyes, instead of this child it needs to be a Stack with childred [positioned, positioned, positioned], each with its own key. The handle add (also called in Done) is a button and when added then instance is made and added to a list.
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
                        ? RecordToolbar(
                            audioPathCallbach: _updateAudioPath,
                          )
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

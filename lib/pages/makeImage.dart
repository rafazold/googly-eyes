import 'dart:typed_data';

import 'package:looney_cam/widgets/popupAlert.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:looney_cam/utilities/handleImage.dart';
import 'package:looney_cam/widgets/eyesToolbar.dart';
import 'package:looney_cam/widgets/pinkButton.dart';
import 'package:looney_cam/widgets/prevButton.dart';
import 'package:looney_cam/widgets/recordToolbar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui' as ui;
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
  GlobalKey stackKey = GlobalKey();
  final textController = TextEditingController();

  double eyesPosX = 100.0;
  double eyesPosy = 200.0;
  double textX = 0;
  double textY = 200;
  String eyesImg = 'assets/eyes/initial/group_84.png';
  double eyesScale = 1.0;
  double eyesBaseSize = 1.0;
  double eyesLastSize;
  List imagesLists = ['eyes', 'face'];
  int currentList = 0;
  String tempDirPath;
  String assetsDirectory;
  String audioPath;
  String imageText = '';
  FocusNode textFocus;

  bool showEyes = false;
  bool loading = false;
  bool hideAppBar = false;
  bool isVideoAnimated = false;
  bool isAudioAnimated = false;
  bool editing = true;
  bool screenshotFinished = true;
  bool showRecordToolbar = false;
  bool showTextField = false;
  Map finalDetails;
  String finalUrl;
  File finalFile;

  final HandleImage handleImages = HandleImage();
  final PopupAlert alert = PopupAlert();

  void handleAddText() {
    setState(() {
      showTextField = true;
      hideAppBar = true;
    });
  }

  @override
  void initState() {
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
    textFocus = FocusNode();
  }

  @override
  void dispose() {
    textFocus.dispose();
    textController.dispose();
    super.dispose();
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
  Future<File> takeScreenshot({bool static}) {
    setState(() {
      screenshotFinished = false;
    });
    return screenshotController
        .capture(delay: Duration(milliseconds: 9), pixelRatio: 3)
        // .then((File image) => image)
        .then((File image) {
      // print('getting closer');
      if (static) {
        setState(() {
          screenshotFinished = true;
        });
      }
      return image;
    }).catchError((onError) {
      // print('onError');
    });
  }

  Future<File> makeScreenShot() async {
    RenderRepaintBoundary boundary = stackKey.currentContext.findRenderObject();
    String timeStamp = (new DateTime.now().millisecondsSinceEpoch).toString();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List pngBytes = byteData.buffer.asUint8List();
    File imgFile = File('$tempDirPath/looney-final_$timeStamp.png');
    setState(() {
      finalFile = imgFile;
    });
    imgFile.writeAsBytes(pngBytes);
    return imgFile;
  }

  void _setInitialEyesPosition(Map eyesPosition) {
    // TODO: when making multiple, instance should have key position updated with method, also when moved needs to be updated.
    if (editing) {
      setState(() {
        eyesPosX = eyesPosition['offsetX'];
        eyesPosy = eyesPosition['offsetY'];
      });
    }
  }

  void _resetEyes() {
    setState(() {
      showEyes = false;
      eyesImg = '';
      eyesPosX = 100.0;
      eyesPosy = 200.0;
    });
  }

  void _updateEyesImg(String imagePath) {
    setState(() {
      eyesImg = imagePath;
      showEyes = true;
    });
  }

  void _updateAudioPath(String path) {
    setState(() {
      audioPath = path;
      isAudioAnimated = true;
    });
  }

  void renderStatic(String bgPath) {
    // RenderBox box = imageKey.currentContext.findRenderObject();
    //TODO: FIX ME!!!
    takeScreenshot(static: true)
        // makeScreenShot()
        .then((imgFile) {
      // print('imgFile: ++++   $imgFile');
      decodeImageFromList(imgFile.readAsBytesSync()).then((asset) {
        // print('renderedStatic');
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
        // print('static rendered with details: $finalDetails');
      });
    });
  }

  void renderAnimation(String bgPath) {
    // print('S T E P ================      1');
    RenderBox bgContainer = imageKey.currentContext.findRenderObject();
    Offset position = bgContainer.localToGlobal(Offset.zero);
    double xOffset = position.dx;
    double yOffset = position.dy;
    double width = bgContainer.size.width;
    double height = bgContainer.size.height;
    RenderBox eyes = eyes1.currentContext.findRenderObject();
    Offset pos = eyes.localToGlobal(Offset.zero);
    double xOff = pos.dx;
    double yOff = pos.dy;
    double wid = eyes.size.width * eyesScale;
    double hei = eyes.size.height * eyesScale;
    // print(
    //     'x: $xOffset - y: $yOffset - width: $width - height: $height == x: $xOff == y: $yOff == w: $wid == h: $hei == scale: $eyesScale');
    // print('$assetsDirectory/$eyesImg');
    // copyFileAssets(
    //     arguments['imgFile'].path, '/animated.gif');
    //TODO: check if image is rendered in the session and if so pass the path rather than prepare the assets again.
    handleImages
        .copyAnimationFromAssetsToTemp(eyesImg, '/animated.png')
        .then((animatedEyesPath) {
      // print('S T E P ================      2');
      takeScreenshot().then((imgFile) {
        // copyFileAssets(assetName, localName).then((imgFile) {
        // print('S T E P ================      3');
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
      });
    });
  }

  void handleDone(String bgPath, String overlayPath) {
    if (!editing) {
      // print('not editing');
      return;
    }
    // print('handleDone after if');
    if (overlayPath.contains('animation')) {
      setState(() {
        isVideoAnimated = true;
      });
      // print('rendering A N I M A T E D: $overlayPath');
      renderAnimation(bgPath);
    } else {
      setState(() {
        isVideoAnimated = false;
      });
      print('rendering S T A T I C: $overlayPath');
      renderStatic(bgPath);
    }
    setState(() {
      editing = false;
      showRecordToolbar = true;
    });
  }

  void handleEdit() {
    // print('edit');
    setState(() {
      editing = true;
      showRecordToolbar = false;
    });
  }

  void handleHelp(context) {
    // print('hello');
    alert.childAlert(context);
  }

  void pleaseWaitAlert(context) {
    alert.textAlert(
      context,
      message: "please wait while we process your Looney image",
      closeButton: 'Close',
    );
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
    if (number <= 1200) {
      return number;
    } else {
      return 1200;
    }
  }

  Future<int> renderFinal(String type) async {
    List<String> arguments;
    String timeStamp = (new DateTime.now().millisecondsSinceEpoch).toString();
    String videoUrl = '$tempDirPath/googly_video-$timeStamp.mp4';
    // String gifUrl = '$tempDirPath/googly_video-$timeStamp.gif';
    // print('will make $type and details: $finalDetails');
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
        "-pix_fmt",
        "yuv420p",
        "-vf",
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
        "15",
        "-i",
        "${finalDetails['eyesPath']}",
        "-filter_complex",
        "[0]scale=w=${makeIntEven(finalDetails['bgW'])}:h=${makeIntEven(finalDetails['bgH'])}[bg], [1]fps=25[fps],[fps]scale=w=${makeIntEven(finalDetails['eyW'])}:h=${makeIntEven(finalDetails['eyH'])}[eyes], [bg][eyes]overlay=${finalDetails['xOff']}:${finalDetails['yOff']}",
        // TODO: if landscape does not solve it (need to implement yet), try passing if portrait or landscape and according to that transpose.
        "-t",
        "5",
        "-codec:a",
        "copy",
        "-preset",
        "veryslow",
        "-async",
        "1",
        "$videoUrl"
      ];
      setState(() {
        finalUrl = videoUrl;
      });
    } else {
      arguments = [
        "-i",
        "${finalDetails['bgPath']}",
        "-stream_loop",
        "-1",
        "-r",
        "25",
        "-i",
        "${finalDetails['eyesPath']}",
        "-filter_complex",
        "[0]${finalDetails['bgH'] >= finalDetails['bgW'] ? 'transpose=dir=1:passthrough=portrait[bgTranspose], [bgTranspose]' : ''}scale=w=${makeIntEven(finalDetails['bgW'])}:h=${makeIntEven(finalDetails['bgH'])}[bg], [1]fps=25[fps],[fps]scale=w=${makeIntEven(finalDetails['eyW'])}:h=${makeIntEven(finalDetails['eyH'])}[eyes], [bg][eyes]overlay=${finalDetails['xOff']}:${finalDetails['yOff']}",
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
    // print('arguments: $arguments');
    int render =
        await _flutterFFmpeg.executeWithArguments(arguments).then((rc) {
      // print('ffmpeg completed with response :::::::::::: $rc');
      return rc;
    });
    // .catchError((e) {
    //   // sentry
    //   // print('E R R O R :     $e');
    //   // alert.textAlert(
    //   //   context,
    //   //   message: "Error on renderFinal-FFMPEG: $e - arguments: $arguments",
    //   //   closeButton: 'Close',
    //   // );
    // });
    return render;
  }

  void handleFinish() {
    try {
      if (!isVideoAnimated && !isAudioAnimated) {
        // print('finished with type static');
        renderFinal('static').then((_) {
          Navigator.pushNamed(context, '/result', arguments: {
            'resultUrl': finalUrl,
            'isVideo': false,
            'videoFile': File(finalUrl),
            'mimeType': 'image/png',
            'fileExtension': 'png'
          });
        }).catchError((onError) {
          alert.textAlert(
            context,
            message: "Error on renderFinal-static: $onError",
            closeButton: 'Close',
          );
        });
      } else if (!isVideoAnimated && isAudioAnimated) {
        renderFinal('audioStatic').then((rc) {
          // print(
          //     'finished with type audiostatic: res: $rc &&&&&& ${finalDetails['bgW']}');
          if (rc == 0) {
            Navigator.pushNamed(context, '/result', arguments: {
              'resultUrl': finalUrl,
              'isVideo': true,
              'videoUrl': finalUrl,
              'videoFile': File(finalUrl),
              'bgW': makeIntEven(finalDetails['bgW']),
              'bgH': makeIntEven(finalDetails['bgH']),
              'mimeType': 'video/mp4',
              'fileExtension': 'mp4'
            });
          }
        }).catchError((onError) {
          alert.textAlert(
            context,
            message: "Error on renderFinal-audioAnimated: $onError",
            closeButton: 'Close',
          );
        });
      } else if (isVideoAnimated && !isAudioAnimated) {
        renderFinal('animated').then((rc) {
          // print('rc is $rc before');
          // print('finished with type animated');
          if (rc == 0) {
            // print('rc is $rc after ifed');
            Navigator.pushNamed(context, '/result', arguments: {
              'resultUrl': finalUrl,
              'isVideo': true,
              'videoUrl': finalUrl,
              'videoFile': File(finalUrl),
              'bgW': makeIntEven(finalDetails['bgW']),
              'bgH': makeIntEven(finalDetails['bgH']),
              'mimeType': 'video/mp4',
              'fileExtension': 'mp4'
            });
          }
        }).catchError((onError) {
          alert.textAlert(
            context,
            message: "Error on renderFinal-audio&video animated: $onError",
            closeButton: 'Close',
          );
        });
        // Navigator.pushNamed(context, '/result',
        //     arguments: {'resultUrl': finalUrl, 'isVideo': false});
      } else if (isVideoAnimated && isAudioAnimated) {
        renderFinal('audioAnimated').then((rc) {
          // print('finished with type audioAnimated');
          // print('finished with type animated');
          if (rc == 0) {
            // print('rc is $rc after ifed');
            Navigator.pushNamed(context, '/result', arguments: {
              'resultUrl': finalUrl,
              'isVideo': true,
              'videoUrl': finalUrl,
              'videoFile': File(finalUrl),
              'bgW': makeIntEven(finalDetails['bgW']),
              'bgH': makeIntEven(finalDetails['bgH']),
              'mimeType': 'video/mp4',
              'fileExtension': 'mp4'
            });
          }
        });
        // Navigator.pushNamed(context, '/result',
        //     arguments: {'resultUrl': finalUrl, 'isVideo': true});
      }

      // Navigator.pushNamed(context, '/share', arguments: passArguments);

      // print('FINISH: audioUrl: $audioPath, overlayUrl: $eyesImg');
      // TODO: make ffmpeg magic, pass to new page for sending
    } catch (e) {
      // print('reset');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final PickedFile bgFile = arguments['imgFile'];
    return loading
        ? Container()
        : Scaffold(
            resizeToAvoidBottomPadding: false,
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
                              enabled: screenshotFinished,
                              buttonText: ' Finish',
                              icon: Icons.done,
                              callback: screenshotFinished
                                  ? handleFinish
                                  : () {
                                      pleaseWaitAlert(context);
                                      throw new StateError(
                                          'This is a Dart exception.');
                                    }),
                      SizedBox(width: 10),
                      editing
                          ? Container()
                          : PinkButton(
                              buttonText: ' Edit',
                              icon: Icons.edit,
                              callback: handleEdit,
                            ),
                      SizedBox(
                        width: 10,
                      ),
                      IconButton(
                          icon: Icon(Icons.help_outline, color: Colors.black),
                          onPressed: () {
                            handleHelp(context);
                          }),
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
                            // print('scale details::::: ----- $details');
                          },
                          onScaleUpdate: (details) {
                            double scaleValue =
                                num.parse(details.scale.toStringAsFixed(2));

                            if (editing) {
                              setState(() {
                                eyesScale =
                                    (eyesBaseSize * scaleValue).clamp(0.1, 5);
                              });
                            }
                          },
                          onScaleEnd: (details) {
                            // print('FINISHED!!! ------->>>> $details');
                            eyesBaseSize = eyesScale;
                          },
                          child: DragTarget<String>(
                            onWillAccept: (d) {
                              // print("on will accept: $editing");
                              return editing;
                            },
                            onAccept: (d) {
                              setState(() {
                                showEyes = true;
                                eyesImg = d;
                              });
                              // print("ACCEPT 2!: $d");
                            },
                            // TODO: use instead of callback for offset
                            onAcceptWithDetails: (details) {
                              // print(
                              //     'acceptWIthDetails = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = ${details.offset}');
                            },
                            builder: (context, list, list2) {
                              // TODO retry with repaintBoundary
                              return Screenshot(
                                controller: screenshotController,
                                child: Stack(key: stackKey, children: [
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
                                              // print(
                                              //     'drag ended: ${details.offset} and accepted: ${details.wasAccepted}');
                                              if (editing &&
                                                  details.wasAccepted) {
                                                setState(() {
                                                  eyesPosX = details.offset
                                                      .dx; //.clamp(-30, 300);
                                                  eyesPosy = details.offset
                                                      .dy; //.clamp(-30, 700);
                                                });
                                              } else if (editing &&
                                                  !details.wasAccepted &&
                                                  details.offset.dy > 100) {
                                                _resetEyes();
                                              }
                                            },
                                            feedback: !editing
                                                ? Container()
                                                : Transform(
                                                    transform:
                                                        Matrix4.diagonal3(
                                                            vector.Vector3(
                                                                eyesScale,
                                                                eyesScale,
                                                                eyesScale)),
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
                                            childWhenDragging: editing
                                                ? Container()
                                                : Transform(
                                                    transform:
                                                        Matrix4.diagonal3(
                                                            vector.Vector3(
                                                                eyesScale,
                                                                eyesScale,
                                                                eyesScale)),
                                                    alignment:
                                                        FractionalOffset.center,
                                                    child: Image.asset(
                                                      eyesImg,
                                                      width: 200,
                                                    )),
                                          ),
                                        ),
                                  Visibility(
                                    visible: showTextField,
                                    child: Positioned(
                                      bottom: 0,
                                      width: 400,
                                      height: 50,
                                      // top: 50,
                                      child: TextField(
                                          onEditingComplete: () {
                                            // print('editComplete');
                                            SystemChrome
                                                .setEnabledSystemUIOverlays([]);
                                          },
                                          controller: textController,
                                          style: TextStyle(color: Colors.white),
                                          focusNode: textFocus,
                                          onChanged: (val) {
                                            setState(() {
                                              imageText = val;
                                            });
                                          },
                                          onSubmitted: (val) {
                                            setState(() {
                                              showTextField = false;
                                              editing = true;
                                              hideAppBar = false;
                                            });
                                          },
                                          decoration: InputDecoration(
                                              hintStyle: TextStyle(
                                                  color: Colors.white),
                                              hintText: "Write something here",
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.white))
                                              // border: OutlineInputBorder(
                                              //   borderRadius:
                                              //       BorderRadius.circular(25),
                                              // )
                                              )),
                                    ),
                                  ),
                                  Positioned(
                                    left: textX,
                                    top: textY,
                                    child: Draggable(
                                      onDragEnd: (details) {
                                        if (editing) {
                                          setState(() {
                                            textX = details.offset.dx;
                                            textY = details.offset.dy;
                                          });
                                        }
                                      },
                                      childWhenDragging: editing
                                          ? Container()
                                          : DefaultTextStyle(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 38,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 3.0,
                                                    color: Colors.black87,
                                                  ),
                                                  Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 8.0,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: AutoSizeText(
                                                  textController.text,
                                                  textAlign: TextAlign.center,
                                                  minFontSize: 10,
                                                  stepGranularity: 5,
                                                  maxLines: 6,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                      feedback: !editing
                                          ? Container()
                                          : DefaultTextStyle(
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 38,
                                                shadows: <Shadow>[
                                                  Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 3.0,
                                                    color: Colors.black87,
                                                  ),
                                                  Shadow(
                                                    offset: Offset(2.0, 2.0),
                                                    blurRadius: 8.0,
                                                    color: Colors.black87,
                                                  ),
                                                ],
                                              ),
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: AutoSizeText(
                                                  textController.text,
                                                  textAlign: TextAlign.center,
                                                  minFontSize: 10,
                                                  stepGranularity: 5,
                                                  maxLines: 6,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8, horizontal: 30),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child:
                                            // Text('yoyoyoyoyo'),
                                            AutoSizeText(
                                          textController.text,
                                          textAlign: TextAlign.center,
                                          minFontSize: 10,
                                          stepGranularity: 5,
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 38,
                                            shadows: <Shadow>[
                                              Shadow(
                                                offset: Offset(2.0, 2.0),
                                                blurRadius: 3.0,
                                                color: Colors.black87,
                                              ),
                                              Shadow(
                                                offset: Offset(2.0, 2.0),
                                                blurRadius: 8.0,
                                                color: Colors.black87,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      // top: 200,
                                      left: 20,
                                      bottom: 20,
                                      child: Image.asset('assets/watermark.png',
                                          height: 40))
                                ]),
                              );
                            },
                          )),
                    ),
                  ),
                  Expanded(
                    child: showRecordToolbar
                        ? RecordToolbar(
                            audioPathCallback: _updateAudioPath,
                            textFocusNode: textFocus,
                            addTextcallback: handleAddText)
                        : EyesToolbar(
                            eyesPossition: _setInitialEyesPosition,
                            updateEyesImg: _updateEyesImg,
                            // resetEyes: _resetEyes
                          ),
                    flex: 10,
                  )
                ],
              ),
            ),
          );
  }
}

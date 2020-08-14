import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:googly_eyes/widgets/recordSound.dart';
// import 'package:googly_eyes/utilities/shareFiles.dart';
import 'package:googly_eyes/utilities/handleFile.dart';
import 'package:googly_eyes/widgets/popupAlert.dart';

class AddVoice extends StatefulWidget {
  @override
  _AddVoiceState createState() => _AddVoiceState();
}

class _AddVoiceState extends State<AddVoice> {
  AssetDetails assetDetails;
  String audioUrl;
  Directory tempDir;
  bool isAudioAnimated = false;
  String videoUrl;
  File videoFile;
  File imageFile;
  bool isRecording = false;

  // final ShareFile _file = ShareFile();
  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();
  final GlobalKey _recordSound = GlobalKey();
  final PopupAlert _alert = PopupAlert();

  void shareFile(file, String mimeType, String ext) async {
    try {
      print('sharing ${file.path}');
      final ByteData bytes = file.readAsBytesSync().buffer.asByteData();
      print('path to bytes');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          fileName: 'googly_eyes.$ext',
          mimeType: mimeType,
          bytesOfFile: bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }

  int makeIntEven(int number) {
    if (number.isEven) {
      return number;
    } else {
      return number - 1;
    }
  }

  int makeMax(int number) {
    if (number <= 1226) {
      return number;
    } else {
      return 1226;
    }
  }

  Future buildVideo(String audioUrl, int width, int height) async {
    tempDir = await getTemporaryDirectory();
    String timeStamp = (new DateTime.now().millisecondsSinceEpoch).toString();
    setState(() {
      videoUrl = '${tempDir.path}/googly_video-$timeStamp.mp4';
    });
    List<String> arguments = [
      "-i",
      "${imageFile.path}",
      "-i",
      "$audioUrl",
      "-loop",
      "1",
      "-c:v",
      "libx264",
      "-t",
      "15",
      "-pix_fmt",
      "yuv420p",
      "-vf",
      "scale=${makeMax(makeIntEven(width))}:-2",
      "$videoUrl"
    ];

    final encoded =
        await _flutterFFmpeg.executeWithArguments(arguments).then((rc) {
      setState(() {
        videoFile = File(videoUrl);
      });
    });
    return videoUrl;
  }

  Future<ByteData> videoToFile(String path) async {
    final videoData = await rootBundle.load(path);
    return videoData;
  }

  // void _clipAlert(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(8.0),
  //         ),
  //         content: const Text('Please add some audio to make a clip'),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Ok'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _updateAudioPath(String path) {
    setState(() {
      audioUrl = path;
      isAudioAnimated = true;
    });
  }

  void _updateRecordingState(recordingState) {
    setState(() {
      print(
          '----------------------------------------------------------------reeeec');
      isRecording = recordingState;
    });
  }

  void _renderAndShowVideo(int width, int height) {
    buildVideo(audioUrl, width, height).then((vidUrl) => {
          // print('this is the video URL: $vidUrl')
          Navigator.pushNamed(context, '/video', arguments: {
            'videoUrl': vidUrl,
            'videoFile': videoFile,
            'width': makeMax(makeIntEven(width)),
            'height': height
          })
        });
  }

  Future getImgDetails(_file) {
    if (assetDetails == null) {
      decodeImageFromList(_file.readAsBytesSync()).then((asset) {
        var details = AssetDetails(_file, asset.width, asset.height);
        setState(() {
          assetDetails = details;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    imageFile = arguments['imgFile'];
    getImgDetails(imageFile); // TODO: find a better way for this function
    print(arguments);
    return Scaffold(
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
              print('share pressed');
              shareFile(imageFile, 'image/png', 'png');
            },
            child: Container(
              width: 80,
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
                  Icon(Icons.share),
                  Text(' Image'),
                ],
              ),
            ),
          ),
          SizedBox(width: 2),
          RawMaterialButton(
            onPressed: () {
              print('pressed');
              getImgDetails(imageFile);
              print('got details');
              isAudioAnimated
                  ? _renderAndShowVideo(assetDetails.width, assetDetails.height)
                  : _alert.textAlert(
                      context, 'Please add some audio to make a clip');
              print('Clip pressed: $audioUrl');
            },
            child: Container(
              width: 80,
              height: 30,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(21),
                  gradient: LinearGradient(
                    colors: isAudioAnimated
                        ? [Color(0xffff0775), Color(0xfffc6c4e)]
                        : [Colors.black, Colors.grey],
                    stops: [0, 1],
                    begin: Alignment(-0.98, 0.19),
                    end: Alignment(0.98, -0.19),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.music_video),
                  Text(' Clip'),
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
              child: arguments['imgFile'] != null
                  ? Stack(
                      alignment: AlignmentDirectional.center,
                      children: <Widget>[
                        Center(
                            child: OverflowBox(
                                minWidth: 0.0,
                                minHeight: 0.0,
                                maxHeight: double.infinity,
                                child: Image.file(arguments['imgFile'])))
                      ],
                    )
                  : Text('No image selected'),
              flex: 5,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffff0077), Color(0xffff724e)],
                    stops: [0, 1],
                    begin: Alignment(-0.93, 0.36),
                    end: Alignment(0.93, -0.36),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RecordSound(
                            pathCallback: _updateAudioPath,
                            startRecordingCallback: _updateRecordingState,
                            key: _recordSound),
                        Text('Record a short message',
                            style: TextStyle(
                              fontFamily: 'HelveticaNeue',
                              color: Color(0xffffffff),
                              fontSize: 18,
                              fontWeight: FontWeight.w100,
                              fontStyle: FontStyle.normal,
                            )),
                      ],
                    ),
                  ],
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

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:googly_eyes/utilities/recordSound.dart';

class AddVoice extends StatefulWidget {
  @override
  _AddVoiceState createState() => _AddVoiceState();
}

class _AddVoiceState extends State<AddVoice> {
  String audioUrl;
  Directory tempDir;
  bool isAudioAnimated = false;
  String videoUrl;
  File imageFile;

  final FlutterFFmpeg _flutterFFmpeg = new FlutterFFmpeg();

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

  void buildVideo(String audioUrl) async {
    tempDir = await getTemporaryDirectory();
    String timeStamp = (new DateTime.now().millisecondsSinceEpoch).toString();
    setState(() {
      videoUrl = '${tempDir.path}/goggly_video-$timeStamp.mp4';
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
      "scale=320:-1",
      "$videoUrl"
    ];

    _flutterFFmpeg
        .executeWithArguments(arguments)
        .then((rc) =>
            print("FFmpeg process exited with rc $rc and saved as $videoUrl"))
        .then((res) => videoPathToBytes(videoUrl)
                // .then((res) => videoToFile(videoUrl)
                .then((file) => shareFile(File(videoUrl), 'video/mp4', 'mp4'))
            // .then((value) => print('seems done'))
            )
        .catchError((e) => print(e));
  }

  Future<Uint8List> videoPathToBytes(String path) async {
    Uint8List assetByteData = await File(path).readAsBytes();
    return assetByteData;
  }

  Future<ByteData> videoToFile(String path) async {
    final videoData = await rootBundle.load(path);
    return videoData;
  }

  void _clipAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          // title: Text('Not in stock'),
          content: const Text('Please add some audio to make a clip'),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateAudioPath(String path) {
    setState(() {
      audioUrl = path;
      isAudioAnimated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    imageFile = arguments['imgFile'];
    print(arguments);
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
          // Container(),
          SizedBox(width: 20),
          RawMaterialButton(
            // onPressed: () { // for SAVE
            //   print('save pressed');
            //   _imageFile = null;
            //   screenshotController
            //       .capture(delay: Duration(milliseconds: 10))
            //       .then((File image) async {
            //     print('Capture Done: ${image.path}');
            //     setState(() {
            //       _imageFile = image;
            //     });
            //     final result =
            //         await GallerySaver.saveImage(image.path).then((path) {
            //       print("File Saved to Gallery: $path");
            //     });
            //   }).catchError((onError) {
            //     print(onError);
            //   });
            // },
            onPressed: () {
              print('share pressed');
              shareFile(arguments['imgFile'], 'image/png', 'png');
              // _imageFile = null;
              // screenshotController
              //     .capture(delay: Duration(milliseconds: 10))
              //     .then((File image) async {
              //   print('Capture Done: ${image.path}');
              //   setState(() {
              //     _imageFile = image;
              //   });
              //   final result =
              //       await GallerySaver.saveImage(image.path).then((path) {
              //     print("File Saved to Gallery: $path");
              //     _shareImage(image.path);
              //   });
              // }).catchError((onError) {
              //   print(onError);
              // });
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
                    // angle: 79,
                    // scale: undefined,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(width: 20),
                  Icon(Icons.share),
                  Text(' Share'),
                  // SizedBox(width: 20),
                ],
              ),
            ),
          ),
          SizedBox(width: 2),
          RawMaterialButton(
            onPressed: () {
              isAudioAnimated ? buildVideo(audioUrl) : _clipAlert(context);
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
                    // angle: 79,
                    // scale: undefined,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // SizedBox(width: 20),
                  Icon(Icons.music_video),
                  Text(' Clip'),
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
              child: arguments['imgFile'] != null
                  ? Center(
                      child: OverflowBox(
                          minWidth: 0.0,
                          minHeight: 0.0,
                          maxHeight: double.infinity,
                          child: Image.file(arguments['imgFile'])))
                  : Text('No image selected'),
              flex: 5,
            ),
            Expanded(
              child: Container(
                // height: 120,
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RecordSound(pathCallback: _updateAudioPath),
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

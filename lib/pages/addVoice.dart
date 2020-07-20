import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/eyesCard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:async';
import 'package:screenshot/screenshot.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:wc_flutter_share/wc_flutter_share.dart';
import 'package:flutter/services.dart';
import 'package:googly_eyes/utilities/recordSound.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';

class AddVoice extends StatefulWidget {
  @override
  _AddVoiceState createState() => _AddVoiceState();
}

class _AddVoiceState extends State<AddVoice> {
  void _shareImage(String path) async {
    try {
      print('starting share');
      final ByteData bytes = await rootBundle.load(path);
      print('path to bytes');
      await WcFlutterShare.share(
          sharePopupTitle: 'share',
          fileName: 'googly_eyes.png',
          mimeType: 'image/png',
          bytesOfFile: bytes.buffer.asUint8List());
    } catch (e) {
      print('error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    bool audioRecorded = false;
    String audioUrl;
    FlutterSoundRecorder recorderModule = FlutterSoundRecorder();

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
              _shareImage(arguments['imgFile']);
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
              print('Clip pressed');
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
                          child: Image.file(File(arguments['imgFile']))))
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
                        RecordSound(),
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

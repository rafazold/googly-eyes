import 'dart:io';

import 'package:looney_cam/widgets/popupAlert.dart';
import 'package:looney_cam/widgets/pinkButton.dart';
import 'package:flutter/material.dart';
import 'package:looney_cam/pages/playVideo.dart';
import 'package:looney_cam/widgets/prevButton.dart';
import 'package:looney_cam/widgets/shareToolbar.dart';

class DisplayResult extends StatefulWidget {
  @override
  _DisplayResultState createState() => _DisplayResultState();
}

class _DisplayResultState extends State<DisplayResult> {
  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    final String resultUrl = arguments['resultUrl'];
    final bool isVideo = arguments['isVideo'];
    final File videoFile = arguments['videoFile'];
    final String mimeType = arguments['mimeType'];
    final String fileExtension = arguments['fileExtension'];
    print('resultUrl: $resultUrl');
    PopupAlert _alert = PopupAlert();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: PrevButton(),
        actions: [
          SizedBox(width: 20),
          PinkButton(
            buttonText: ' Reset',
            icon: Icons.replay,
            callback: () {
              _alert.textAlert(
                context,
                message: "Sure, let's start over!",
                closeButton: 'Close',
                buttons: [
                  FlatButton(
                    child: Text("Reset"),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                      print('lets reset');
                    },
                  )
                ],
              );
              print('reset');
            },
          ),
          SizedBox(width: 20),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              flex: 64,
              child: isVideo
                  ? PlayVideo(
                      videoUrl: resultUrl,
                      bgW: arguments['bgW'],
                      bgH: arguments['bgH'],
                    )
                  // ? Container()
                  : OverflowBox(
                      minWidth: 0.0,
                      minHeight: 0.0,
                      maxHeight: double.infinity,
                      child: Container(
                        child: Image.file(File(resultUrl)),
                      ))),
          Expanded(
              flex: 10,
              child: ShareToolbar(
                  finalUrl: resultUrl,
                  videoFile: videoFile,
                  mimeType: mimeType,
                  fileExtension: fileExtension,
                  isVideo: isVideo))
        ],
      ),
    );
  }
}

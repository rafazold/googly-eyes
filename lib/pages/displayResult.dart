import 'dart:io';

import 'package:flutter/material.dart';
import 'package:googly_eyes/pages/playVideo.dart';
import 'package:googly_eyes/widgets/shareToolbar.dart';

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
    return Scaffold(
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

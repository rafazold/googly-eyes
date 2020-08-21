import 'package:flutter/material.dart';
import 'package:googly_eyes/widgets/recordSound.dart';

class RecordToolbar extends StatefulWidget {
  RecordToolbar({Key key, this.startRecordingCallback, this.audioPathCallbach})
      : super(key: key);

  final startRecordingCallback;
  final audioPathCallbach;

  @override
  _RecordToolbarState createState() => _RecordToolbarState();
}

class _RecordToolbarState extends State<RecordToolbar> {
  String videoPath;
  String audioUrl;
  bool isAudioAnimated = false;

  @override
  void initState() {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toolbar changed!!!');
    super.initState();
  }

  // void _updateAudioPath(String path) {
  //   setState(() {
  //     audioUrl = path;
  //     isAudioAnimated = true;
  //   });
  // }

  void setVideoPath(path) {
    setState(() {
      videoPath = path;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                RecordSound(pathCallback: widget.audioPathCallbach),
                SizedBox(
                  height: 10,
                ),
                Text('Tap to record a short message',
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
        ));
  }
}

// pass to video widget as arguments: width, height, videoUrl

import 'package:flutter/material.dart';
import 'package:looney_cam/widgets/recordSound.dart';

class RecordToolbar extends StatefulWidget {
  RecordToolbar({
    Key key,
    this.startRecordingCallback,
    this.audioPathCallback,
    this.textFocusNode,
    this.addTextcallback,
  }) : super(key: key);

  final startRecordingCallback;
  final audioPathCallback;
  final textFocusNode;
  final addTextcallback;

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RecordSound(pathCallback: widget.audioPathCallback),
                SizedBox(
                  height: 10,
                ),
                Text('Record',
                    style: TextStyle(
                      fontFamily: 'HelveticaNeue',
                      color: Color(0xffffffff),
                      fontSize: 18,
                      fontWeight: FontWeight.w100,
                      fontStyle: FontStyle.normal,
                    )),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  padding: EdgeInsets.all(0),
                  iconSize: 53,
                  onPressed: () {
                    widget.addTextcallback();
                    widget.textFocusNode.requestFocus();
                    print('hello now');
                  },
                  icon: Icon(
                    Icons.subtitles,
                  ),
                  // size: 53,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text('Type',
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

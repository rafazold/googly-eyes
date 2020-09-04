import 'dart:async';

import 'package:flutter/material.dart';
import 'package:looney_cam/widgets/recordSound.dart';

class RecordToolbar extends StatefulWidget {
  RecordToolbar({
    Key key,
    // this.startRecordingCallback,
    this.audioPathCallback,
    this.textFocusNode,
    this.addTextcallback,
  }) : super(key: key);

  // final startRecordingCallback;
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
  bool isRecording = false;
  String runningTimer = '00.00';
  Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>toolbar changed!!!');
    super.initState();
  }

  @override
  void dispose() {
    stopTimer();
    super.dispose();
  }

  // void _updateAudioPath(String path) {
  //   setState(() {
  //     audioUrl = path;
  //     isAudioAnimated = true;
  //   });
  // }

  void startTimer() {
    print(
        'timer started !!!!!!!!!!!!!! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! ! !  !  !  !  !  !  !  !  !  !  !   !   !   !   !   !    !     !     !      !     !');
    formatTime(Duration d) => d.toString().split('.').last.padLeft(8, "0");
    Timer _timer;
    _stopwatch.reset();
    _stopwatch.start();
    runningTimer = '00.00';
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_stopwatch.elapsedMilliseconds < 20000) {
        setState(() {
          runningTimer =
              // 11,238
              // formatTime(_stopwatch.elapsed); 1,234
              '${_stopwatch.elapsed.inSeconds.toString().padLeft(2)}:${(_stopwatch.elapsed.inMilliseconds).remainder(100).toString().padLeft(2, '0')}';
        });
      } else {
        _timer.cancel();
      }
    });
  }

  void stopTimer() {
    _stopwatch.stop();
  }

  void handleRecording(recording) {
    if (recording) {
      setState(() {
        isRecording = true;
      });
      startTimer();
    } else {
      stopTimer();
      setState(() {
        isRecording = false;
      });
    }
  }

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
            Container(
              width: 100,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RecordSound(
                      pathCallback: widget.audioPathCallback,
                      notifyRecordingCallback: handleRecording,
                    ),
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
              ),
            ),
            isRecording
                ? Container(
                    width: 150,
                    // child: Text('$runningTimer / 20.0'),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '$runningTimer / 20:00',
                          style: TextStyle(
                            fontFamily: 'HelveticaNeue',
                            color: Color(0xffffffff),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                        SizedBox(
                          height: 31,
                        )
                      ],
                    ),
                  )
                : Container(
                    width: 150,
                    child: Column(
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
                  ),
          ],
        ));
  }
}

// pass to video widget as arguments: width, height, videoUrl

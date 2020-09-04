import 'dart:async';

import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:looney_cam/widgets/popupAlert.dart';
import 'package:intl/intl.dart' show DateFormat;

class RecordSound extends StatefulWidget {
  const RecordSound(
      {Key key, @required this.pathCallback, this.notifyRecordingCallback})
      : super(key: key);
  final ValueChanged<String> pathCallback;
  final ValueChanged notifyRecordingCallback;

  @override
  _RecordSoundState createState() => _RecordSoundState();
}

class _RecordSoundState extends State<RecordSound> {
  String audioPath;
  FlutterSoundRecorder audioRecorder;
  PermissionStatus status;
  Directory tempDir;
  bool recording = false;
  File outputFile;
  bool readyToRecord = false;

  StreamSubscription _recorderSubscription;

  final PopupAlert alert = PopupAlert();
  AudioCache player = AudioCache(prefix: 'audio/');

  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  @override
  void dispose() {
    print('audio recorder disposed &*&*&*&*&*&*&*&**&*&*&*&*&');
    audioRecorder
        .closeAudioSession()
        .then((_) => print('audio session closed'));
    audioRecorder = null;
    super.dispose();
  }

  void checkPermissions() async {
    audioRecorder = await FlutterSoundRecorder().openAudioSession();
    status = await Permission.microphone.request();
    tempDir = await getTemporaryDirectory();
    outputFile = File('${tempDir.path}/goggly_sound-tmp.aac');
    // get assets folder
    if (status == PermissionStatus.granted && tempDir != null) {
      setState(() {
        readyToRecord = true;
      });
      print('++++++++++++++++++++++++++all ready');
    } else {
      print('somethings wrong here!');
    }
  }

  void cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
      _recorderSubscription = null;
    }
  }

  void startRecording() async {
    if (audioRecorder.isInited.toString() == 'Initialized.notInitialized') {
      audioRecorder = await FlutterSoundRecorder().openAudioSession();
      print('audio session inited');
    }
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");
    await audioRecorder.startRecorder(toFile: outputFile.path);
    setState(() {
      recording = true;
      audioPath = outputFile.path;
    });
    widget.notifyRecordingCallback(true);
    player
        .play('start-recording.mp3', volume: 1.0)
        .catchError((e) => print('ERROR in player: $e'));

    _recorderSubscription = audioRecorder.onProgress.listen((e) {
      if (e != null && e.duration > Duration(seconds: 20)) {
        print(e.duration);
        cancelRecorderSubscriptions();
        endRecording();
        // if (e.duration > Duration(seconds: 1) &&
        //     e.duration < Duration(seconds: 3)) {}
        // DateTime date = new DateTime.fromMillisecondsSinceEpoch(
        //     e.duration.inMilliseconds,
        //     isUtc: true);
        // String txt = DateFormat('mm:ss:SS', 'en_GB').format(date);
        print('txt');
      }
    });
  }

  void endRecording() async {
    await audioRecorder.stopRecorder();
    player
        .play('end-recording.mp3', volume: 0.5)
        .catchError((e) => print('ERROR in player: $e'));
    setState(() {
      recording = false;
    });
    print('recorded to: $audioPath');
    audioRecorder.closeAudioSession();
    cancelRecorderSubscriptions();
    widget.pathCallback(audioPath);
    widget.notifyRecordingCallback(false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipOval(
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
              recording ? Colors.blueGrey[300] : Colors.transparent,
              BlendMode.color),
          child: recording
              ? Icon(
                  Icons.stop,
                  size: 53,
                )
              : Image.asset(
                  'assets/record_icon.png',
                  height: 53,
                ),
        ),
      ),
      onLongPress: () {
        // widget.startRecordingCallback(true);
        startRecording();
        print('should record: status: ');
      },
      onLongPressUp: endRecording,
      onTap: () {
        recording ? endRecording() : startRecording();
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:googly_eyes/pages/addVoice.dart';

class RecordSound extends StatefulWidget {
  // final CallbackImage callbackImage;
  const RecordSound({Key key, @required this.pathCallback}) : super(key: key);
  final ValueChanged<String> pathCallback;

  @override
  _RecordSoundState createState() => _RecordSoundState();
}

class _RecordSoundState extends State<RecordSound> {
  String audioPath;
  FlutterSoundRecorder audioRecorder;
  FlutterSoundRecorder audioPlayer;
  PermissionStatus status;
  Directory tempDir;
  File outputFile;
  @override
  void initState() {
    checkPermissions();
    super.initState();
  }

  void checkPermissions() async {
    status = await Permission.microphone.request();
    tempDir = await getTemporaryDirectory();
    outputFile = await File('${tempDir.path}/goggly_sound-tmp.aac');
    if (status == PermissionStatus.granted && tempDir != null) {
      print('all ready');
    } else {
      print('somethings wrong here!');
    }
  }

  void startRecording() async {
    audioRecorder = await FlutterSoundRecorder().openAudioSession();
    if (status != PermissionStatus.granted)
      throw RecordingPermissionException("Microphone permission not granted");
    await audioRecorder.startRecorder(toFile: outputFile.path);
    setState(() {
      audioPath = outputFile.path;
    });
  }

  void endRecording() async {
    await audioRecorder.stopRecorder();
    print('recorded to: $audioPath');
    widget.pathCallback(audioPath);
    audioRecorder.closeAudioSession();
  }

  void playRecording() async {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // iconSize: 53,
      child: Image.asset(
        'assets/record_icon.png',
        height: 53,
      ),
      onLongPress: () {
        startRecording();
        print('should record: status: ');
      },
      onLongPressUp: endRecording,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
  bool recording = false;
  File outputFile;

  // final GlobalKey _recordSound = GlobalKey();

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
    if (status == PermissionStatus.granted && tempDir != null) {
      print('all ready');
    } else {
      print('somethings wrong here!');
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
  }

  void endRecording() async {
    await audioRecorder.stopRecorder();
    setState(() {
      recording = false;
    });
    print('recorded to: $audioPath');
    audioRecorder.closeAudioSession();
    widget.pathCallback(audioPath);
  }

  void playRecording() async {}

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // iconSize: 53,
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
        startRecording();
        print('should record: status: ');
      },
      onLongPressUp: endRecording,

      onTap: recording ? endRecording : startRecording,
    );
  }
}

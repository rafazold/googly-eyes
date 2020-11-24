import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:looney_cam/widgets/popupAlert.dart';
import 'package:flutter_screen_recording/flutter_screen_recording.dart';
// TODO: implement passbacks

class RecordVideo extends StatefulWidget {
  const RecordVideo(
      {Key key,
      @required this.pathCallback,
      this.startRecordingCallback,
      this.isAudioAnimated})
      : super(key: key);
  final ValueChanged<String> pathCallback;
  final ValueChanged startRecordingCallback;
  final bool isAudioAnimated;

  @override
  _RecordVideoState createState() => _RecordVideoState();
}

class _RecordVideoState extends State<RecordVideo> {
  String videoPath;
  PermissionStatus status;
  Map<Permission, PermissionStatus> statuses;
  Directory tempDir;
  bool recording = false;
  File outputFile;

  final PopupAlert alert = PopupAlert();

  @override
  void initState() {
    _checkPermissions();
    _initVariables();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initVariables() async {
    tempDir = await getTemporaryDirectory();
    outputFile = File('${tempDir.path}/goggly_sound-tmp.aac');
  }

  void _checkPermissions() async {
    statuses = await [
      Permission.microphone,
      Permission.storage,
      Permission.photos
    ].request();
    // get assets folder
  }

  void recordScreen(bool audio) async {
    if (audio) {
      print('record session inited');
      await FlutterScreenRecording.startRecordScreenAndAudio(
          "googly-animation");
    } else {
      await FlutterScreenRecording.startRecordScreen("googly-animation");
      setState(() {
        recording = true;
      });
      widget.startRecordingCallback(true);
    }
  } // add setState(() => recording = !recording); when implementing

  // void startRecording() async {
  //   if (audioRecorder.isInited.toString() == 'Initialized.notInitialized') {
  //     audioRecorder = await FlutterSoundRecorder().openAudioSession();
  //   }
  //   if (status != PermissionStatus.granted)
  //     throw RecordingPermissionException("Microphone permission not granted");
  //   await audioRecorder.startRecorder(toFile: outputFile.path);
  //   setState(() {
  //     recording = true;
  //     videoPath = outputFile.path;
  //   });
  //   widget.startRecordingCallback(true);
  //   player
  //       .play('start-recording.mp3')
  //       .catchError((e) => print('ERROR in player: $e'));
  // }

  Future stopRecordScreen() async {
    String path = await FlutterScreenRecording.stopRecordScreen;
    setState(() {
      recording = false;
      videoPath = path;
    });
    print('recorded to: $path');
    widget.pathCallback(path);
    widget.startRecordingCallback(false);
    return path;
  }

  // void endRecording() async {
  //   await audioRecorder.stopRecorder();
  //   player
  //       .play('end-recording.mp3')
  //       .catchError((e) => print('ERROR in player: $e'));
  //   setState(() {
  //     recording = false;
  //   });
  //   audioRecorder.closeAudioSession();
  //   widget.pathCallback(videoPath);
  //   widget.startRecordingCallback(false);
  // }

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
        widget.startRecordingCallback(true);
        recordScreen(widget.isAudioAnimated);
        print('should record: status: ');
      },
      onLongPressUp: stopRecordScreen,
      onTap: () {
        recording ? stopRecordScreen() : recordScreen(widget.isAudioAnimated);
      },
    );
  }
}

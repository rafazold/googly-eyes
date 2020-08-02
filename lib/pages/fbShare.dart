import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  bool loading = true;
  bool videoReady = false;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.file(File(
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  void _initController(String videoLink) {
    _controller = VideoPlayerController.network(videoLink)
      ..initialize().then((_) {
        setState(() {
          videoReady = true;
          // _controller = _controller;
        });
        //do what you want.
      });
  }

  Future<void> _startVideoPlayer(String videoLink) async {
    if (_controller == null) {
      // If there was no controller, just create a new one
      _initController(videoLink);
    } else {
      // If there was a controller, we need to dispose of the old one first
      final oldController = _controller;

      // Registering a callback for the end of next frame
      // to dispose of an old controller
      // (which won't be used anymore after calling setState)
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await oldController.dispose();

        // Initing new controller
        _initController(videoLink);
      });

      // Making sure that controller is not used by setting it to null

      setState(() {
        _controller = null;
      });
    }
  }

  // void initPlayer() {
  //   _controller = VideoPlayerController.network(
  //       'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
  //     ..initialize().then((_) {
  //       // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
  //       setState(() {
  //         loading = false;
  //       });
  //     });
  // }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    // _startVideoPlayer(
    //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4');
    // initPlayer();
    return loading
        ? Scaffold(
            body: Center(
            child: FloatingActionButton(
              onPressed: () {
                _startVideoPlayer(arguments['videoUrl']).then((value) {
                  setState(() {
                    print(
                        'YOYOYOYOOYOYOYOYOY ==========>>>> and controller $_controller');
                    // _controller.value.isPlaying
                    //     ? _controller.pause()
                    //     : _controller.play();
                    loading = false;
                    videoReady = true;
                  });
                }).then((_) {
                  print(
                      'CONTROLLER CONTROLLER CONTROLLER---------------------------------- $_controller');
                  _controller.play();
                });
              },
              child: Text('PRESS HERE'),
            ),
          ))
        : Scaffold(
            body: Center(
              child: _controller.value.initialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container(),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (!videoReady) {
                  print(
                      '======>>>>>>>=========>>>>>>==========>>>>>> ${arguments['videoUrl']}');
                  _startVideoPlayer(arguments['videoUrl']).then((value) {
                    setState(() {
                      print(
                          'YOYOYOYOOYOYOYOYOY ==========>>>> and controller $_controller');
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                      videoReady = true;
                    });
                  });
                } else {
                  print('VIDEO READY???????????????????????');
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                    videoReady = true;
                  });
                }
              },
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

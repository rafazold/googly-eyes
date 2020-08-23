import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:googly_eyes/pages/splash.dart';
import 'package:googly_eyes/utilities/shareFiles.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  PlayVideo({this.videoUrl});

  final videoUrl;

  @override
  _PlayVideoState createState() => _PlayVideoState();
}

class _PlayVideoState extends State<PlayVideo> {
  VideoPlayerController _controller;
  // bool loading = true;
  bool videoReady = false;
  // final ShareFile _file = ShareFile();
  int width;
  int height;

  @override
  void initState() {
    super.initState();
    // _controller = VideoPlayerController.network(
    //     '/data/user/0/com.example.googly_eyes/cache/googly_video-1598123991129.mp4')
    //   ..initialize().then((_) {
    //     print('I DONT UNDERSTAND THIS');
    //     setState(() {
    //       videoReady = true;
    //     });
    //   });
    _startVideoPlayer(
        '/data/user/0/com.example.googly_eyes/cache/googly_video-1598123991129.mp4');
  }

  void _initController(String videoLink) {
    print('C O N T R O L E R => init');
    _controller = VideoPlayerController.network(videoLink)
      ..initialize().then((_) {
        setState(() {
          videoReady = true;
        });
      });
  }

  Future<void> _startVideoPlayer(String videoLink) async {
    if (_controller == null) {
      // If there was no controller, just create a new one
      _initController(widget.videoUrl);
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

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    width = arguments['width'];
    height = arguments['height'];
    final vidRatio = width / height;
    print('VIDEO URL: ${widget.videoUrl}');

    // void goToVideo() {
    //   _startVideoPlayer(arguments['videoUrl']).then((value) {
    //     setState(() {
    //       loading = false;
    //       videoReady = true;
    //     });
    //   }).then((_) {
    //     print(
    //         'CONTROLLER CONTROLLER CONTROLLER---------------------------------- $_controller');
    //     _controller.play();
    //   });
    // }

    return
        // loading
        //     ? Scaffold(
        //         body: Center(
        //         child: Splash(
        //           pressFunction: goToVideo,
        //           pageTitle: 'Click to play video',
        //           useContext: false,
        //         ),
        //       ))
        //     :
        Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: <Widget>[
          Center(
            child: _controller.value.initialized
                ? Transform.scale(
                    scale: 1,
                    child: AspectRatio(
                      aspectRatio: vidRatio,
                      child: VideoPlayer(_controller),
                    ),
                  )
                : Container(),
          ),
          FloatingActionButton(
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
                print(
                    'VIDEO READY??????????????????????? position:  ${_controller.value.position} lengthL ${_controller.value.duration}');
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

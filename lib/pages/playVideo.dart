import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayVideo extends StatefulWidget {
  PlayVideo({this.videoUrl, this.bgW, this.bgH});

  final videoUrl;
  final bgW;
  final bgH;

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
    _startVideoPlayer(widget.videoUrl);
  }

  void _initController(String videoLink) {
    print('C O N T R O L E R => init');
    _controller = VideoPlayerController.network(videoLink)
      ..initialize().then((_) {
        setState(() {
          videoReady = true;
        });
      });
    _controller.setLooping(true);
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
    width = widget.bgW;
    height = widget.bgH;
    final vidRatio = width / height;
    print('VIDEO URL: ${widget.videoUrl}');

    return Scaffold(
      extendBodyBehindAppBar: true,
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:
            _controller.value.isPlaying ? Color(0xffff724e) : Color(0xffff0077),
        onPressed: () {
          if (!videoReady) {
            print(
                '======>>>>>>>=========>>>>>>==========>>>>>> ${widget.videoUrl}');
            _startVideoPlayer(widget.videoUrl).then((value) {
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

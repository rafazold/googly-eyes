import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:looney_cam/pages/splash.dart';
import 'package:looney_cam/utilities/shareFiles.dart';
import 'package:video_player/video_player.dart';

class VideoApp extends StatefulWidget {
  @override
  _VideoAppState createState() => _VideoAppState();
}

class _VideoAppState extends State<VideoApp> {
  VideoPlayerController _controller;
  bool loading = true;
  bool videoReady = false;
  final ShareFile _file = ShareFile();
  int width;
  int height;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(
        'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
  }

  void _initController(String videoLink) {
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

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    width = arguments['width'];
    height = arguments['height'];
    final vidRatio = width / height;

    void goToVideo() {
      _startVideoPlayer(arguments['videoUrl']).then((value) {
        setState(() {
          loading = false;
          videoReady = true;
        });
      }).then((_) {
        print(
            'CONTROLLER CONTROLLER CONTROLLER---------------------------------- $_controller');
        _controller.play();
      });
    }

    return loading
        ? Scaffold(
            body: Center(
            child: Splash(
              pressFunction: goToVideo,
              pageTitle: 'Click to play video',
              useContext: false,
            ),
          ))
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              // centerTitle: true,
              title: RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Opacity(
                      opacity: 0.25999999046325684,
                      child: Container(
                          width: 67.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(21))),
                    ),
                    Text('Back'),
                  ],
                ),
              ),
              actions: <Widget>[
                // Container(),
                SizedBox(width: 20),
                RawMaterialButton(
                  onPressed: () {
                    _file.shareFile(arguments['videoFile'], 'video/mp4', 'mp4');
                  },
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        gradient: LinearGradient(
                          colors: [Color(0xffff0775), Color(0xfffc6c4e)],
                          stops: [0, 1],
                          begin: Alignment(-0.98, 0.19),
                          end: Alignment(0.98, -0.19),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.share),
                        Text(' Share'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 2),
                RawMaterialButton(
                  onPressed: () {
                    GallerySaver.saveVideo(arguments['videoUrl'])
                        .then((path) {
                          print("File Saved to Gallery: $path");
                        })
                        .then((_) => {_file.alert(context, 'Clip Saved')})
                        .catchError((onError) {
                          print(onError);
                        });
                  },
                  child: Container(
                    width: 80,
                    height: 30,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(21),
                        gradient: LinearGradient(
                          colors: [Color(0xffff0775), Color(0xfffc6c4e)],
                          stops: [0, 1],
                          begin: Alignment(-0.98, 0.19),
                          end: Alignment(0.98, -0.19),
                        )),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.save),
                        Text(' Save'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
              ],
            ),
            body: Column(
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
          );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:googly_eyes/utilities/shareFiles.dart';
// import 'package:flutter_sound_lite/flutter_sound.dart';
// import 'package:googly_eyes/widgets/recordSound.dart';

class ShareToolbar extends StatefulWidget {
  ShareToolbar(
      {Key key,
      this.finalUrl,
      this.videoFile,
      this.mimeType,
      this.fileExtension,
      this.isVideo})
      : super(key: key);

  final finalUrl;
  final videoFile;
  final mimeType;
  final fileExtension;
  final isVideo;

  @override
  _ShareToolbarState createState() => _ShareToolbarState();
}

class _ShareToolbarState extends State<ShareToolbar> {
  ShareFile share = ShareFile();
  // String videoPath;
  // String audioUrl;
  // bool isAudioAnimated = false;

  @override
  void initState() {
    print(
        '>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Share changed!!! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<');
    super.initState();
  }

  // void setVideoPath(path) {
  //   setState(() {
  //     videoPath = path;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                // RecordSound(pathCallback: widget.audioPathCallbach),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                  ),
                  height: 85,
                  width: 85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        iconSize: 40,
                        onPressed: () {
                          share.save(widget.finalUrl, widget.isVideo).then((_) {
                            share.alert(
                                context, 'Your Looney Cam creation was Saved');
                          });
                          print(
                              'Save presed: ${widget.finalUrl}, ${widget.mimeType}, ${widget.fileExtension}');
                        },
                      ),
                      // SizedBox(height: 10),
                      Text(
                        'Save',
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: 'HelveticaNeue',
                            fontSize: 20,
                            letterSpacing: 0.666),
                      )
                    ],
                  ),
                ),
                SizedBox(width: 80),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white24,
                  ),
                  height: 85,
                  width: 85,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                        ),
                        iconSize: 40,
                        onPressed: () {
                          share.shareFile(widget.videoFile, widget.mimeType,
                              widget.fileExtension);
                          print('Share presed');
                        },
                      ),
                      // SizedBox(height: 10),
                      Text(
                        'Share',
                        style: TextStyle(
                            color: Color(0xffffffff),
                            fontFamily: 'HelveticaNeue',
                            fontSize: 20,
                            letterSpacing: 0.666),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

// pass to video widget as arguments: width, height, videoUrl

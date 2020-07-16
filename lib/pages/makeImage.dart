import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/getImage.dart';
import 'package:googly_eyes/utilities/eyesCard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class MakeImage extends StatefulWidget {
  @override
  _MakeImageState createState() => _MakeImageState();
}

class _MakeImageState extends State<MakeImage> {
  // SelectImage _image = SelectImage();
  ScrollController _controller = new ScrollController();
  String _assetsPath;

  @override
  void initState() {
    getEyes().then((path) => setState(() {
          _assetsPath = path;
        }));
    super.initState();
  }

  Future<String> getEyes() async {
    print('#############################################');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    print('yoooooo: $appDocPath');
    return appDocPath;
    // final eyesDir = new Directory('/assets');
    // eyesDir
    //     .list(recursive: true, followLinks: false)
    //     .listen((FileSystemEntity entity) {
    //   print(entity.path);
    // });
  }

  Future printPath() async {
    final dir = Directory('$_assetsPath/flutter_assets/');
    final files = await dir
        .list(recursive: true, followLinks: false)
        .listen((FileSystemEntity entity) {
      print(entity.path);
    });
    ;
    print('+++++++++++++++++++++++++++++++++++++++++++++++++$files');
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments = ModalRoute.of(context).settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(
        title: FlatButton(onPressed: printPath, child: Text('get Eyes')),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: arguments['imgFile'] != null
                    ? Image.asset(arguments['imgFile'].path)
                    : Text('No image selected'),
              ),
              flex: 7,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffff0077), Color(0xffff724e)],
                    stops: [0, 1],
                    begin: Alignment(-0.93, 0.36),
                    end: Alignment(0.93, -0.36),
                    // angle: 69,
                    // scale: undefined,
                  ),
                ),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(), // new
                  controller: _controller,
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png'),
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png'),
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png'),
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png'),
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png'),
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png'),
                    EyesCard(
                        index: 1,
                        onPress: () {},
                        eyes: 'assets/eyes/initial/group_84.png')
                  ],
                ),
              ),
              flex: 1,
            )
          ],
        ),
      ),
    );
  }
}

// ConstrainedBox(
//         constraints: BoxConstraints.tightFor(height: max(500, constraints.maxHeight)),
//         child: Column(),

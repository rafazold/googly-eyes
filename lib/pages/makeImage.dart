import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:googly_eyes/utilities/getImage.dart';
import 'package:googly_eyes/utilities/eyesCard.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class MakeImage extends StatefulWidget {
  @override
  _MakeImageState createState() => _MakeImageState();
}

class _MakeImageState extends State<MakeImage> {
  // SelectImage _image = SelectImage();
  ScrollController _controller = new ScrollController();
  String _assetsPath;
  Map droppedEyes = {
    'xPos': 0,
    'yPos': 0,
    'img': '',
  };
  List someImages;
  @override
  void initState() {
    getEyes().then((path) => setState(() {
          _assetsPath = path;
        }));
    _initImages('initial');
    super.initState();
  }

  Future _initImages(String batch) async {
    // >> To get paths you need these 2 lines
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);
    // >> To get paths you need these 2 lines

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('eyes/$batch'))
        .where((String key) => key.contains('.png'))
        .toList();

    setState(() {
      someImages = imagePaths;
    });
  }

  Future<String> getEyes() async {
    print('#############################################');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    print('yoooooo: $appDocPath');
    return appDocPath;
  }

  Future printPath() async {
    _initImages('initial')
        .then((value) => someImages.forEach((element) => print(element)));
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
              child: DragTarget(builder: (context, list, list2) {
                return Stack(children: [
                  arguments['imgFile'] != null
                      ? Image.asset(arguments['imgFile'].path)
                      : Text('No image selected'),
                ]);
              }),
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
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(), // new
                    controller: _controller,
                    scrollDirection: Axis.horizontal,
                    itemCount: someImages.length,
                    itemBuilder: (context, index) {
                      return EyesCard(
                          index: index,
                          onPress: () {},
                          imagePath: someImages[index]);
                    },
                  )),
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

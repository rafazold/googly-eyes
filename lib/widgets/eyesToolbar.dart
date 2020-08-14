import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:googly_eyes/widgets/eyesCard.dart';
import 'package:path_provider/path_provider.dart';

class EyesToolbar extends StatefulWidget {
  EyesToolbar({Key key, @required this.eyesPossition, this.updateEyesImg})
      : super(key: key);

  final eyesPossition;
  final updateEyesImg;

  @override
  _EyesToolbarState createState() => _EyesToolbarState();
}

class _EyesToolbarState extends State<EyesToolbar> {
  ScrollController _controller = new ScrollController();
  List someImages = [];
  List imagesLists = ['eyes', 'mouth', 'face', 'animation'];
  int currentList = 0;
  String eyesImg = 'assets/eyes/initial/group_84.png';

  @override
  void initState() {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>HELLO MISTER!!!');
    _initImages(imagesLists[currentList]);
    super.initState();
  }

  Future _initImages(String batch) async {
    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    final imagePaths = manifestMap.keys
        .where((String key) => key.contains('eyes/initial/$batch'))
        .where((String key) => key.contains('.png') || key.contains('.gif'))
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity > 0 && currentList - 1 >= 0) {
          setState(() {
            currentList--;
          });
        } else if (details.primaryVelocity < 0 &&
            currentList + 1 < imagesLists.length) {
          setState(() {
            currentList++;
          });
        }
        _initImages(imagesLists[currentList]);

        print(
            '${details.primaryVelocity}, - {direction(details.primaryVelocity)} $currentList');
      },
      child: DragTarget(
        builder: (context, list, list2) {
          return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xffff0077), Color(0xffff724e)],
                  stops: [0, 1],
                  begin: Alignment(-0.93, 0.36),
                  end: Alignment(0.93, -0.36),
                ),
              ),
              // TODO: try with Silverlist or SilverGrid to use one big list
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _controller,
                scrollDirection: Axis.horizontal,
                itemCount: someImages.length,
                itemBuilder: (context, index) {
                  return EyesCard(
                    index: index,
                    onPress: () {
                      widget.updateEyesImg(someImages[index]);
                    },
                    imagePath: someImages[index],
                    eyesPossition: widget.eyesPossition,
                  );
                },
              ));
        },
      ),
    );
  }
}
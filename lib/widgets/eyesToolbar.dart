import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:googly_eyes/widgets/eyesCard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class EyesToolbar extends StatefulWidget {
  EyesToolbar({Key key, @required this.eyesPossition, this.updateEyesImg})
      : super(key: key);

  final eyesPossition;
  final updateEyesImg;

  @override
  _EyesToolbarState createState() => _EyesToolbarState();
}

class _EyesToolbarState extends State<EyesToolbar> {
  final ScrollController _controller = new ScrollController();

  List draggableImages = [];
  // List imagesLists = ['eyes', 'mouth', 'face', 'animation'];
  List imagesLists = [
    // 'eyes/color-1',
    'eyes/color-2',
    'eyes/color-3',
    'eyes/color-5',
    'eyes/color-7',
    'face/face-6',
    'face/face-7'
  ];
  int currentList = 0;
  String eyesImg = '';

  @override
  void initState() {
    print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>HELLO MISTER!!!');
    _initImages(imagesLists[currentList]);
    super.initState();
  }

  Future _initImages(String batch) async {
    List imagePaths = [];

    final manifestContent =
        await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

    final Map<String, dynamic> manifestMap = json.decode(manifestContent);

    if (batch == 'animation') {
      imagePaths = manifestMap.keys
          .where((String key) => key.contains('overlays/initial/$batch'))
          .where((String key) => key.contains('.gif'))
          .toList();
    } else {
      imagePaths = manifestMap.keys
          .where((String key) => key.contains('overlays/initial/$batch'))
          .where((String key) => key.contains('.png'))
          .toList();
    }

    setState(() {
      draggableImages = imagePaths;
    });
  }

  Future<String> getEyes() async {
    print('#############################################');
    Directory appDocDir = await getApplicationDocumentsDirectory();
    String appDocPath = appDocDir.path;

    print('yoooooo: $appDocPath');
    return appDocPath;
  }

  void handleNextList() {
    print('doing next');
    if (currentList + 1 < imagesLists.length) {
      print('ifed');
      setState(() {
        currentList++;
      });
      print(currentList);
    } else {
      print('elsed');
      setState(() {
        currentList = 0;
      });
    }
    _initImages(imagesLists[currentList]);
  }

  void handlePrevList() {
    if (currentList - 1 >= 0) {
      setState(() {
        currentList--;
      });
    } else {
      setState(() {
        currentList = imagesLists.length - 1;
      });
    }
    _initImages(imagesLists[currentList]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity > 0) {
          handlePrevList();
        } else if (details.primaryVelocity < 0) {
          handleNextList();
        }
      },
      child: DragTarget(
        // TODO: use https://pub.dev/packages/step_progress_indicator to make vertical indicator
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
            height: 90,
            child: Scrollbar(
              controller: _controller,
              isAlwaysShown: true,
              child: Row(
                children: [
                  StepProgressIndicator(
                    totalSteps: imagesLists.length,
                    currentStep: currentList + 1,
                    direction: Axis.vertical,
                    selectedColor: Colors.grey[700],
                    unselectedColor: Colors.grey,
                    roundedEdges: Radius.circular(10),
                    padding: 0,
                    size: 5,
                  ),
                  Expanded(
                    child: ListView.builder(
                      // TODO: make a list within the list
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: _controller,
                      scrollDirection: Axis.horizontal,
                      itemCount: draggableImages.length,
                      itemBuilder: (context, index) {
                        return EyesCard(
                          index: currentList + index,
                          onPress: () {
                            widget.updateEyesImg(draggableImages[index]);
                          },
                          imagePath: draggableImages[index],
                          eyesPossition: widget.eyesPossition,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // child: Column(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Container(
            //       child: ButtonTheme(
            //         height: 22,
            //         child: RaisedButton(
            //           color: Colors.transparent,
            //           elevation: 0,
            //           materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //           // padding: EdgeInsets.all(7),
            //           onPressed: handleNextList,
            //           child: Center(
            //             child: Container(
            //               child: SizedBox(
            //                 // height: 20,
            //                 child: Icon(
            //                   Icons.keyboard_arrow_up,
            //                   color: Colors.white,
            //                   size: 20,
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Container(
            //       height: 90,
            //       child: ListView.builder(
            //         physics: const AlwaysScrollableScrollPhysics(),
            //         controller: _controller,
            //         scrollDirection: Axis.horizontal,
            //         itemCount: draggableImages.length,
            //         itemBuilder: (context, index) {
            //           return EyesCard(
            //             index: currentList + index,
            //             onPress: () {
            //               widget.updateEyesImg(draggableImages[index]);
            //             },
            //             imagePath: draggableImages[index],
            //             eyesPossition: widget.eyesPossition,
            //           );
            //         },
            //       ),
            //     ),
            //   ],
            // )
          );
        },
      ),
    );
  }
}

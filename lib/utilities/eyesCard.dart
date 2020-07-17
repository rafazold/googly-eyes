import 'package:flutter/material.dart';
import 'dart:async';

class EyesCard extends StatefulWidget {
  EyesCard(
      {@required this.index, @required this.onPress, @required this.imagePath});

  final index;
  final Function onPress;
  final imagePath;

  @override
  _EyesCardState createState() => _EyesCardState();
}

class _EyesCardState extends State<EyesCard> {
  StreamController<double> controller = StreamController<double>();

  Future<String>() {}

// Future _initImages(String batch) async {
//     // >> To get paths you need these 2 lines
//     final manifestContent =
//         await DefaultAssetBundle.of(context).loadString('AssetManifest.json');

//     final Map<String, dynamic> manifestMap = json.decode(manifestContent);
//     // >> To get paths you need these 2 lines

//     final imagePaths = manifestMap.keys
//         .where((String key) => key.contains('eyes/$batch'))
//         .where((String key) => key.contains('.png'))
//         .toList();

//     setState(() {
//       someImages = imagePaths;
//     });
//   }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
        child: Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                  color: Color(0x21000000),
                  offset: Offset(0, 1),
                  blurRadius: 12,
                  spreadRadius: 0)
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
                child: LongPressDraggable<String>(
                    onDragStarted: () => print("DRAG START!"),
                    onDragCompleted: () => print("DRAG COMPLETED!"),
                    onDragEnd: (details) {
                      print(
                          'details::::::::::::::::::::::::::::::::   ${details.offset}');
                    },
                    data: widget.imagePath,
                    child: Image.asset(widget.imagePath),
                    feedback: Image.asset(widget.imagePath)),
                fit: BoxFit.scaleDown),
          ),
        ),
      ),
    );
  }
}

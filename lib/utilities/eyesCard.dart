import 'package:flutter/material.dart';
// import 'dart:async';

class EyesCard extends StatefulWidget {
  EyesCard(
      {Key key,
      @required this.index,
      @required this.onPress,
      @required this.imagePath,
      @required this.eyesPossition})
      : super(key: key);
  final ValueChanged<Map> eyesPossition;
  final index;
  final Function onPress;
  final imagePath; //TODO: make eyesImage as map and pass position

  @override
  _EyesCardState createState() => _EyesCardState();
}

class _EyesCardState extends State<EyesCard> {
  // StreamController<double> controller = StreamController<double>();

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
                      widget.eyesPossition({
                        'offsetX': details.offset.dx,
                        'offsetY': details.offset.dy
                      });
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

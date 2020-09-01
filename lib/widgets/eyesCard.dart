import 'package:flutter/material.dart';

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
  final imagePath;

  @override
  _EyesCardState createState() => _EyesCardState();
}

class _EyesCardState extends State<EyesCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(child: child, scale: animation);
        },
        child: Padding(
          key: ValueKey(widget.index),
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 4),
          child: RawMaterialButton(
            onPressed: () {
              widget.onPress();
            },
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
                        child: Image.asset(
                          widget.imagePath,
                          width: 200,
                        ),
                        feedback: Image.asset(
                          widget.imagePath,
                          width: 200,
                        )),
                    fit: BoxFit.scaleDown),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

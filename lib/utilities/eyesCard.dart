import 'package:flutter/material.dart';

class EyesCard extends StatelessWidget {
  EyesCard(
      {@required this.index, @required this.onPress, @required this.imagePath});

  final index;
  final Function onPress;
  final imagePath;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            child:
                FittedBox(child: Image.asset(imagePath), fit: BoxFit.scaleDown),
          ),
        ),
      ),
    );
  }
}

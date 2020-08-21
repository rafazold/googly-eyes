import 'package:flutter/material.dart';

class PrevButton extends StatelessWidget {
  PrevButton();

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
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
    );
  }
}

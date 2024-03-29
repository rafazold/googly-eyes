import 'package:flutter/material.dart';

class PinkButton extends StatelessWidget {
  PinkButton(
      {Key key, this.buttonText, this.icon, this.callback, this.enabled = true})
      : super(key: key);
  final String buttonText;
  final IconData icon;
  final Function callback;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: callback,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.6,
        child: Container(
          width: 89,
          height: 30,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(21),
              gradient: LinearGradient(
                colors: enabled
                    ? [Color(0xffff0775), Color(0xfffc6c4e)]
                    : [Color(0xff880e4f), Color(0xff880e4f)],
                stops: [0, 1],
                begin: Alignment(-0.98, 0.19),
                end: Alignment(0.98, -0.19),
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon),
              Text(buttonText),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash(
      {Key key, @required this.pageTitle, this.pressFunction, this.useContext})
      : super(key: key);
  final String pageTitle;
  final Function pressFunction;
  final bool useContext;
  @override
  Widget build(BuildContext context) {
    print(pageTitle);
    return Scaffold(
        backgroundColor: const Color(0xffffffff),
        body: RawMaterialButton(
          onPressed: useContext ? () => pressFunction(context) : pressFunction,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-0.74, 0.91),
                end: Alignment(0.9, -1.07),
                colors: [Color(0xffff0077), Color(0xffff724e)],
                stops: [0.0, 1.0],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'googly eyes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontFamily: 'FredokaOne',
                  ),
                  textAlign: TextAlign.left,
                ),
                AnimatedContainer(
                  curve: Curves.fastOutSlowIn,
                  duration: Duration(seconds: 10),
                  child: Center(
                    child: Image.asset(
                      'assets/eye_icon.png',
                      width: 200,
                    ),
                  ),
                ),
                SizedBox(
                  height: 180,
                ),
                Text(pageTitle,
                    style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontFamily: 'HelveticaNeue',
                        fontWeight: FontWeight.w100)),
              ],
            ),
          ),
        ));
  }
}

// const String _svg_c5rxus =
//     '<svg viewBox="10.4 88.8 186.9 108.5" ><path transform="translate(-158.33, -313.1)" d="M 355.6400756835938 416.9438781738281 C 355.6400756835938 468.5625 313.7931518554688 510.4058532714844 262.1780395507813 510.4058532714844 C 210.5592956542969 510.4058532714844 168.7160186767578 468.5625 168.7160186767578 416.9438781738281 C 168.7160186767578 365.3250122070313 210.5592956542969 463.4997253417969 262.1780395507813 463.4997253417969 C 313.7931518554688 463.4997253417969 355.6400756835938 365.3250122070313 355.6400756835938 416.9438781738281 Z" fill="#00ffff" fill-opacity="0.4" stroke="none" stroke-width="1" stroke-opacity="0.4" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
// const String _svg_jcuh7b =
//     '<svg viewBox="127.4 62.6 22.9 22.9" ><path transform="translate(-73.07, -332.19)" d="M 223.3606109619141 406.2785339355469 C 223.3606109619141 412.5978698730469 218.2388458251953 417.7232055664063 211.9195709228516 417.7232055664063 C 205.5967102050781 417.7232055664063 200.4750061035156 412.5978698730469 200.4750061035156 406.2785339355469 C 200.4750061035156 399.9593811035156 205.5967102050781 394.833984375 211.9195709228516 394.833984375 C 218.2388458251953 394.833984375 223.3606109619141 399.9593811035156 223.3606109619141 406.2785339355469 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
// const String _svg_ef4y49 =
//     '<svg viewBox="0.0 0.0 299.1 229.1" ><path transform="translate(-153.5, -355.93)" d="M 452.5755004882813 505.4704284667969 C 452.5755004882813 588.058837890625 385.6247863769531 585.0005493164063 303.0362548828125 585.0005493164063 C 220.44775390625 585.0005493164063 153.4969940185547 588.058837890625 153.4969940185547 505.4704284667969 C 153.4969940185547 422.8817749023438 220.44775390625 355.9309692382813 303.0362548828125 355.9309692382813 C 385.6247863769531 355.9309692382813 452.5755004882813 422.8817749023438 452.5755004882813 505.4704284667969 Z" fill="none" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
// const String _svg_dp3ty9 =
//     '<svg viewBox="1297.2 293.2 299.1 229.1" ><path transform="translate(1143.68, -62.74)" d="M 452.5755004882813 505.4704284667969 C 452.5755004882813 588.058837890625 385.6247863769531 585.0005493164063 303.0362548828125 585.0005493164063 C 220.44775390625 585.0005493164063 153.4969940185547 588.058837890625 153.4969940185547 505.4704284667969 C 153.4969940185547 422.8817749023438 220.44775390625 355.9309692382813 303.0362548828125 355.9309692382813 C 385.6247863769531 355.9309692382813 452.5755004882813 422.8817749023438 452.5755004882813 505.4704284667969 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';
// const String _svg_iud9ot =
//     '<svg viewBox="1417.7 346.5 152.0 161.6" ><path transform="translate(1265.0, 64.96)" d="M 238.2404327392578 423.2737426757813 C 238.2404327392578 434.1950988769531 229.3861541748047 443.0494079589844 218.4647216796875 443.0494079589844 C 207.5432739257813 443.0494079589844 198.6890106201172 434.1950988769531 198.6890106201172 423.2737426757813 C 198.6890106201172 412.3523559570313 207.5432739257813 403.4979248046875 218.4647216796875 403.4979248046875 C 229.3861541748047 403.4979248046875 238.2404327392578 412.3523559570313 238.2404327392578 423.2737426757813 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /><path transform="translate(1231.52, 25.1)" d="M 233.6746978759766 412.37939453125 C 233.6746978759766 425.4858093261719 223.0518035888672 436.1087951660156 209.9454040527344 436.1087951660156 C 196.8389282226563 436.1087951660156 186.2160034179688 425.4858093261719 186.2160034179688 412.37939453125 C 186.2160034179688 399.2729187011719 196.8389282226563 388.6500549316406 209.9454040527344 388.6500549316406 C 223.0518035888672 388.6500549316406 233.6746978759766 399.2729187011719 233.6746978759766 412.37939453125 Z" fill="#ffffff" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /><path transform="translate(1276.86, -23.93)" d="M 203.1049957275391 370.4010314941406 C 203.1049957275391 370.4010314941406 283.6153564453125 384.4028015136719 288.8660583496094 466.6634521484375 C 315.1194152832031 366.9005432128906 203.1049957275391 370.4010314941406 203.1049957275391 370.4010314941406 Z" fill="#dff3fd" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>';

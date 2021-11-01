/**
 * Author: Siddhartha Joshi
 * profile: https://github.com/cimplesid
  */
import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:lcss_mobile_app/Util/constant.dart';

class Intro5 extends StatefulWidget {
  Intro5(this.color);

  final Color color;

  @override
  _Intro5State createState() => _Intro5State();
}

const brightYellow = Color(0xFFFFD300);
const darkYellow = Color(0xFFFFB900);

class _Intro5State extends State<Intro5> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: FlareActor(
              'assets/flare/bus.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'driving',
            ),
          ),
          // Flexible(
          //   flex: 2,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.white,
          //       elevation: 4,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(50)),
          //     ),
          //     child: Text(
          //       'Tap here to proceed',
          //       style: TextStyle(color: Colors.black54),
          //     ),
          //     onPressed: () => Navigator.pushNamed(context, "/home"),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class Intro6 extends StatefulWidget {
  Intro6(this.color);

  final Color color;

  @override
  _Intro6State createState() => _Intro6State();
}

class _Intro6State extends State<Intro6> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: FlareActor(
              'assets/flare/loading.flr',
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              animation: 'Alarm',
            ),
          ),
        ],
      ),
    );
  }
}

class Intro7 extends StatefulWidget {
  const Intro7(this.color);

  final Color color;

  @override
  _Intro7State createState() => _Intro7State();
}

class _Intro7State extends State<Intro7> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: FlareActor(
              'assets/flare/cloud.flr',
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              animation: '1298-floating-cloud',
            ),
          ),
        ],
      ),
    );
  }
}

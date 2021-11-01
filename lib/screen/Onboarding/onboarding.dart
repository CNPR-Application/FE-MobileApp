/**
 * Author: Siddhartha Joshi
 * profile: https://github.com/cimplesid
  */
import 'package:flare_flutter/base/animation/actor_animation.dart';
import 'package:flare_flutter/flare.dart';
import 'package:flare_flutter/flare_controller.dart';
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

class Intro8 extends StatefulWidget {
  const Intro8(this.color);

  final Color color;

  @override
  _Intro8State createState() => _Intro8State();
}

class _Intro8State extends State<Intro8> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: FlareActor(
              'assets/flare/empty.flr',
              alignment: Alignment.center,
              fit: BoxFit.scaleDown,
              animation: 'idle',
            ),
          ),
        ],
      ),
    );
  }
}

class Intro9 extends StatefulWidget {
  const Intro9(this.color);

  final Color color;

  @override
  _Intro9State createState() => _Intro9State();
}

class _Intro9State extends State<Intro9> {
  SlowMoController _controller = SlowMoController("Animations", speed: 0.3);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.color,
      body: Column(
        children: [
          Flexible(
            flex: 8,
            child: FlareActor(
              'assets/flare/welcome.flr',
              alignment: Alignment.center,
              fit: BoxFit.contain,
              animation: 'Animations',
              controller: _controller,
            ),
          ),
          Flexible(
              flex: 2,
              child: Container(
                margin: EdgeInsets.all(30),
                child: Text(
                  "Chào mừng bạn lần đầu đến với ứng dụng dành cho học sinh LCSS",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              )),
          Flexible(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50)),
              ),
              child: Text(
                'Nhấn vào đây để tiếp tục',
                style: TextStyle(color: Colors.black54),
              ),
              onPressed: () => Navigator.pushNamed(context, "/home"),
            ),
          ),
        ],
      ),
    );
  }
}

class SlowMoController extends FlareController {
  final String animationName;
  ActorAnimation _animation;
  double speed;
  double _time = 0;

  SlowMoController(this.animationName, {this.speed = 1});

  @override
  bool advance(FlutterActorArtboard artboard, double elapsed) {
    if (_animation == null) {
      return false;
    }
    if (_animation.isLooping) {
      _time %= _animation.duration;
    }
    _animation.apply(_time, artboard, 1.0);
    _time += elapsed * speed;
    // Stop advancing if animation is done and we're not looping.
    return _animation.isLooping || _time < _animation.duration;
  }

  @override
  void initialize(FlutterActorArtboard artboard) {
    _animation = artboard.getAnimation(animationName);
  }

  @override
  void setViewTransform(Mat2D viewTransform) {
    // intentionally empty, we don't need the viewTransform in this controller
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

List findTarget(int r, double x, double y) {
  double top = 1, left = 1;
  double angle = Random().nextDouble() * 2 * pi;
  top = x + r * cos(angle);
  left = y + r * sin(angle);
  if (top < 832 && left < 600) {
    return [top, left];
  } else {
    return findTarget(r, x, y);
  }
}

class Experiment extends StatefulWidget {
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  double topRandom = Random().nextInt(350).toDouble() + 250.0;
  double leftRandom = Random().nextInt(320).toDouble();
  List Target = [100, 100];
  int width = 50;
  int dist = 200;
  @override
  void initState() {
    print("initstate function ran------------");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String inputMethod;
    inputMethod = ModalRoute.of(context).settings.arguments;
    print("build function ran----");
    return Scaffold(
      appBar: AppBar(
        title: Text("Experiment Started! - Type : $inputMethod"),
      ),
      body: InkWell(
        onTap: () {
          print("Stack Tapped!!!!");
        },
        child: Stack(
          children: [
            newStartPoint(),
            Positioned(
              child: TargetPoint(200),
              top: 100,
              left: 50,
            )
          ],
        ),
      ),
    );
  }

  Widget newStartPoint() => Positioned(
        height: 100,
        width: 100,
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Text("A"),
          onPressed: () {
            setState(() {
              topRandom = Random().nextInt(350).toDouble() + 250.0;
              leftRandom = Random().nextInt(320).toDouble();
              Target = findTarget(100, topRandom, leftRandom);
              // print("topRandom is $topRandom");
              // print("leftRandom is $leftRandom");
              print("Target is on $Target");
            });
          },
        ),
        top: topRandom,
        left: leftRandom,
      );
}

class StartingPoint extends StatefulWidget {
  @override
  _StartingPointState createState() => _StartingPointState();
}

class _StartingPointState extends State<StartingPoint> {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.amber,
      child: Text("A"),
      onPressed: () {},
    );
  }
}

class TargetPoint extends StatefulWidget {
  int buttonHeight = 50;
  TargetPoint(targetSize) {
    buttonHeight = targetSize;
  }
  @override
  _TargetPointState createState() => _TargetPointState();
}

class _TargetPointState extends State<TargetPoint> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: widget.buttonHeight.toDouble(),
      color: Colors.red[800],
      shape: CircleBorder(),
      onPressed: () {
        // Navigator.pop(context);
        setState(() {
          TargetPoint(200);
        });
      },
      child: Text('TARGET'),
    );
  }
}

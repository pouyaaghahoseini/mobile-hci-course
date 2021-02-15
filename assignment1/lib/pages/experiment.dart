import 'dart:math';
import 'package:flutter/material.dart';

class Experiment extends StatefulWidget {
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  // double topRandom, leftRandom;
  double topRandom = Random().nextInt(350).toDouble() + 250.0;
  double leftRandom = Random().nextInt(320).toDouble();

  @override
  void initState() {
    print("initstate function ran");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("build function ran");
    return Scaffold(
      appBar: AppBar(
        title: Text("Experiment Started!"),
      ),
      body: Stack(
        children: [
          newPoint(),
          Positioned(
            child: TargetPoint(200),
            top: 100,
            left: 50,
          )
        ],
      ),
    );
  }

  Widget newPoint() => Positioned(
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Text("A"),
          onPressed: () {
            setState(() {
              topRandom = Random().nextInt(350).toDouble() + 250.0;
              leftRandom = Random().nextInt(320).toDouble();
              print("topRandom is $topRandom");
              print("leftRandom is $leftRandom");
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

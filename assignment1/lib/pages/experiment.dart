import 'dart:math';
import 'package:flutter/material.dart';

List findStart(double w) {
  double top;
  double left;
  top = Random().nextDouble() * (832.0 - 2 * w) + (w);
  left = Random().nextDouble() * (600.0 - 2 * w) + (w);
  return [top, left];
}

List findTarget(double r, double w, double x, double y) {
  double top;
  double left;
  double angle = Random().nextDouble() * 2 * pi; // generates a random angle.
  top = x + r * cos(angle);
  left = y + r * sin(angle);
  if (top - w > 0 && top + w < 832 && left - w > 0 && left + w < 600) {
    return [top, left]; // TODO: make sure buttons don't overlap.
  } else {
    return findTarget(r, w, x, y);
  }
}

class Experiment extends StatefulWidget {
  // Previous name was SecondRoute.
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  double topRandom = 300.0;
  double leftRandom = 530.0;
  // double topRandom = Random().nextInt(350).toDouble() +
  // 250.0; // Generate topRandom for start. TODO: change numbers.
  // double leftRandom = Random().nextInt(320).toDouble(); // TODO: change numbers.
  double targetTop = 100.0;
  double targetLeft = 100.0;
  List startPoint = [300.0, 300.0];
  List targetPoint = [100.0, 100.0];
  bool startVisible = true;
  bool targetVisible = false;
  bool startTapped = false;
  double startWidth = 70.0;
  double targetwidth = 120.0; // So are these two.
  double dist = 200.0;
  @override
  void initState() {
    print(
        "initstate function ran------------"); // just to track what's going on.
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String inputMethod;
    inputMethod = ModalRoute.of(context)
        .settings
        .arguments; // get the input method from home page. Thumb or Index
    print("build function ran----"); // just to track what's going on.
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
            newTargetPoint(),
          ],
        ),
      ),
    );
  }

  Widget newStartPoint() => Positioned(
        height: startWidth,
        width: startWidth,
        child: Visibility(
          visible: startVisible,
          child: FloatingActionButton(
            heroTag: 'start',
            backgroundColor: Colors.green[400],
            child: Text("Start"),
            onPressed: () {
              setState(() {
                startVisible = !startVisible;
                startTapped = true;
                // print("topRandom is $topRandom");
                // print("leftRandom is $leftRandom");
              });
            },
          ),
        ),
        top: topRandom,
        left: leftRandom,
      );
  Widget newTargetPoint() => Positioned(
        height: targetwidth,
        width: targetwidth,
        child: FloatingActionButton(
          heroTag: 'target',
          backgroundColor: Colors.red[600],
          child: Text("Target"),
          onPressed: () {
            setState(() {
              if (startTapped == true) {
                startVisible = !startVisible;
                startTapped = false;
                startPoint = findStart(startWidth);
                topRandom = startPoint[0];
                leftRandom = startPoint[1];
                targetPoint =
                    findTarget(dist, targetwidth, topRandom, leftRandom);
                targetTop = targetPoint[0];
                targetLeft = targetPoint[1];
                // print("Target is on $targetPoint");
              }
            });
          },
        ),
        top: targetTop,
        left: targetLeft,
      );
}

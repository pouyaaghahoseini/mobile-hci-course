import 'package:csv/csv.dart';

import 'dart:math';
import 'package:flutter/material.dart';

String csv = const ListToCsvConverter().convert(yourListOfLists);
const int eachtrialrep = 10;
List W = [60.0, 140.0, 180.0];
List A = [100.0, 200.0, 450.0];
const double startWidth = 110.0;

class Trial {
  Trial(this.id, this.width, this.a);
  int id;
  double width;
  double a;
  int errors = 0;
  double mt = 0;
  void printTrial() {
    print("ID:$id " +
        " -- Width:$width " +
        "-- A:$a" +
        "-- errors:$errors" +
        "-- MT:$mt");
  }

  void increaseErrors() {
    errors += 1;
  }

  void addMT(double t) {
    mt += t;
  }
}

List makeDeck() {
  List deck = [];
  for (int i = 1; i < A.length * W.length + 1; i++) {
    for (int j = 1; j < eachtrialrep; j++) {
      deck.add(i);
    }
  }
  return deck;
}

List makeTrials() {
  List trials = [];
  for (int i = 0; i < W.length; i++) {
    for (int j = 0; j < A.length; j++) {
      Trial temp = Trial(A.length * i + j + 1, W[i], A[j]);
      trials.add(temp);
    }
  }
  return trials;
}

List findStart() {
  double top;
  double left;
  top = Random().nextDouble() * (832.0 - 2 * startWidth) + (startWidth);
  left = Random().nextDouble() * (600.0 - 2 * startWidth) + (startWidth);
  return [top, left];
}

List findTarget(double r, double tw, double x, double y) {
  double top;
  double left;
  double angle;

  // double a = sqrt(pow(x-tw, 2) + pow(y-tw, 2) );
  if (x <= 416.0) {
    if (y <= 300.0) {
      angle = Random().nextDouble() * 0.5 * pi;
    } else {
      angle = Random().nextDouble() * 0.5 * pi + 1.5 * pi;
    }
  } else {
    if (y <= 300.0) {
      angle = Random().nextDouble() * 0.5 * pi + 0.5 * pi;
    } else {
      angle = Random().nextDouble() * 0.5 * pi + pi;
    }
  }
  top = x + r * cos(angle);
  left = y + r * sin(angle);
  if (top < x + startWidth &&
      top + tw > x &&
      left < y + startWidth &&
      left + tw > y) {
    return findTarget(r, tw, x, y);
  }
  if (top - tw > 0 && top + tw < 832 && left - tw > 0 && left + tw < 600) {
    return [top, left];
  }
  return findTarget(r, tw, x, y);
}

class Experiment extends StatefulWidget {
  // Previous name was SecondRoute.
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  List deck = makeDeck();
  List trials = makeTrials();
  int id = 1;
  double topRandom = 300.0;
  double leftRandom = 500.0;
  double targetTop = 100.0;
  double targetLeft = 100.0;
  List startPoint;
  List targetPoint;
  bool startVisible = true;
  bool startTapped = false;
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
          trials[id - 1].increaseErrors();
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
            if (deck.isNotEmpty) {
              setState(() {
                if (startTapped == true) {
                  startVisible = !startVisible;
                  startTapped = false;
                  startPoint = findStart();
                  topRandom = startPoint[0];
                  leftRandom = startPoint[1];
                  int idx = Random().nextInt(deck.length);
                  id = deck[idx];
                  targetwidth = trials[id - 1].width;
                  dist = trials[id - 1].a;
                  targetPoint =
                      findTarget(dist, targetwidth, topRandom, leftRandom);
                  targetTop = targetPoint[0];
                  targetLeft = targetPoint[1];
                  deck.removeAt(idx);
                  // print("Target is on $targetPoint");
                }
              }); //setState
            } //if
            else {
              Navigator.pop(context);
            }
          }, //onPressed
        ),
        top: targetTop,
        left: targetLeft,
      );
}

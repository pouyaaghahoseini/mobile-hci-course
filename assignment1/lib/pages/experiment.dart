import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

const int eachtrialrep = 10;
List W = [50.0, 100.0, 150.0];
List A = [300.0, 380.0, 460.0];
const double startWidth = 110.0;

class Trial {
  Trial(this.id, this.width, this.a);
  int id;
  double width;
  double a;
  int errors = 0;
  double mt = 0;
  void printTrial() {
    print("ID:$id," +
        " Width:$width," +
        " A:$a," +
        " errors:$errors," +
        " MT:$mt");
  }

  String toStr() {
    String temp = ("ID " +
        "$id " +
        "Width " +
        "$width " +
        "A " +
        "$a " +
        "errors " +
        "$errors " +
        "MT " +
        "$mt" +
        "\n");
    return temp;
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
    for (int j = 0; j < eachtrialrep; j++) {
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
  double starttop;
  double startleft;
  starttop = Random().nextDouble() * (888.0 - startWidth) + 24.0;
  startleft = Random().nextDouble() * (600.0 - startWidth);
  return [starttop, startleft];
}

List findTarget(double r, double tw, double x, double y) {
  double endtop;
  double endleft;
  double angle;
  angle = Random().nextDouble() * 2 * pi;
  // if (x <= 456.0) {
  //   if (y <= 300.0) {
  //     angle = Random().nextDouble() * 0.5 * pi;
  //   } else {
  //     angle = Random().nextDouble() * 0.5 * pi + 1.5 * pi;
  //   }
  // } else {
  //   if (y <= 300.0) {
  //     angle = Random().nextDouble() * 0.5 * pi + 0.5 * pi;
  //   } else {
  //     angle = Random().nextDouble() * 0.5 * pi + pi;
  //   }
  // }
  endtop = x + r * cos(angle);
  endleft = y + r * sin(angle);
  if (endtop < x + startWidth &&
      endtop + tw > x &&
      endleft < y + startWidth &&
      endleft + tw > y) {
    return findTarget(r, tw, x, y);
  }
  if (endtop > 24.0 && endtop + tw < 832 && endleft > 0 && endleft + tw < 600) {
    return [endtop, endleft];
  }
  return findTarget(r, tw, x, y);
}

class Experiment extends StatefulWidget {
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  List deck = makeDeck();
  List trials = makeTrials();
  int id = 1;
  double topRandom;
  double leftRandom;
  double targetTop;
  double targetLeft;
  List startPoint;
  List targetPoint;
  bool startVisible = true;
  bool startTapped = false;
  double targetwidth = 120.0; // So are these two.
  double dist = 200.0;
  DateTime startTime, endTime;
  int movementTime;
  String filepath = ("/storage/emulated/0/Download/");
  String fileName;
  @override
  void initState() {
    startPoint = findStart();
    topRandom = startPoint[0];
    leftRandom = startPoint[1];
    int idx = Random().nextInt(deck.length);
    id = deck[idx];
    targetwidth = trials[id - 1].width;
    dist = trials[id - 1].a;
    targetPoint = findTarget(dist, targetwidth, topRandom, leftRandom);
    targetTop = targetPoint[0];
    targetLeft = targetPoint[1];
    deck.removeAt(idx);
    print(
        "initstate function ran------------"); // just to track what's going on.
    super.initState();
  }

  Future<File> get _localFile async {
    return File("$filepath" + "/" + "$fileName" + ".txt");
  }

  Future<File> writeMessage(String message) async {
    final file = await _localFile;
    return file.writeAsString(message, mode: FileMode.write);
  }

  @override
  Widget build(BuildContext context) {
    fileName = ModalRoute.of(context).settings.arguments;
    print("build function ran----");
    return Scaffold(
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
                startTime = DateTime.now();
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
                  movementTime =
                      DateTime.now().difference(startTime).inMilliseconds;
                  trials[id - 1].addMT(movementTime.toDouble());
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
              String message = "";
              for (int i = 0; i < trials.length; i++) {
                message += trials[i].toStr();
                trials[i].printTrial();
              }
              writeMessage(message);
              Navigator.pop(context);
            }
          }, //onPressed
        ),
        top: targetTop,
        left: targetLeft,
      );
}

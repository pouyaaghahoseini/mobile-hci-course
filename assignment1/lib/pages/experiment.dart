import 'dart:math';
import 'package:flutter/material.dart';

List findTarget(int r, double x, double y) {
  // This functions finds a suitable random target for the start button.
  double top,
      left; // This is the top and left padding for target. we return them as a List.
  double angle = Random().nextDouble() * 2 * pi; // generates a random angle.
  top = x +
      r * cos(angle); // with angle and radius we can make a pythagorean triangle.
  left = y + r * sin(angle);
  if (top < 832 && left < 600) {
    //check if the point falls in the screen.
    return [top, left]; // TODO: make sure buttons don't overlap.
  } else {
    // TODO: make sure the buttons fit entirely in the screen.
    return findTarget(r, x, y); // recursive call to make another try.
  }
}

class Experiment extends StatefulWidget {
  // Previous name was SecondRoute.
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  double topRandom = Random().nextInt(350).toDouble() +
      250.0; // Generate topRandom for start. TODO: change numbers.
  double leftRandom = Random().nextInt(320).toDouble(); // TODO: change numbers.
  List Target = [100, 100]; // 100 is Trivial.
  int width = 50; // So are these two.
  int dist = 200;
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
        // this is for finding errors. when user taps white screen this triggers. luckily doesn't trigger for buttons.
        onTap: () {
          print("Stack Tapped!!!!");
        },
        child: Stack(
          children: [
            newStartPoint(), // This function makes a random start point
            Positioned(
              // haven't got time to work on this. yet.
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
        height: 100, // TODO: gotta choose 3 of these
        width: 100, // and these. (A, W).
        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Text("A"),
          onPressed: () {
            setState(() {
              topRandom = Random().nextInt(350).toDouble() +
                  250.0; // Make a new random position.
              leftRandom = Random().nextInt(320).toDouble();
              Target = findTarget(100, topRandom, leftRandom);
              // print("topRandom is $topRandom");
              // print("leftRandom is $leftRandom");
              print("Target is on $Target"); // just to track what's going on.
            });
          },
        ),
        top: topRandom, // used those random numbers here.
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

import 'dart:math';

import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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

class AWList {
  //for listAW
  AWList(this.aValue, this.wValue);

  final int aValue;

  final int wValue;
}

class Experiment extends StatefulWidget {
/////////writing starts

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print("!!!!!!this is the app directory: " + directory.path);
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/data.txt');
  }

  Future<File> writeContent(String dataToWrite) async {
    final file = await _localFile;
    // Write the file
    return file.writeAsString(dataToWrite);
  }

  ///writing ends

  // Previous name was SecondRoute.
  @override
  _ExperimentState createState() => _ExperimentState();
}

class _ExperimentState extends State<Experiment> {
  final listAW = [
    //lets say for now (4 instead of 9) and (3 instead of 10) => 12 conditions
    AWList(50, 40),
    AWList(50, 90),
    AWList(100, 40),
    AWList(100, 90),
    AWList(50, 40),
    AWList(50, 90),
    AWList(100, 40),
    AWList(100, 90),
    AWList(50, 40),
    AWList(50, 90),
    AWList(100, 40),
    AWList(100, 90),
  ];

  int counterTargetHit = 0; //to see how many times user hit the target

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
            newTargetPoint(), // This function makes a random start point
            Positioned(
              // haven't got time to work on this. yet.
              child: StartPoint(200),
              top: topRandom + listAW[counterTargetHit].aValue.toDouble(),
              left: leftRandom + listAW[counterTargetHit].aValue.toDouble(),
            )
          ],
        ),
      ),
    );
  }

  Widget newTargetPoint() => Positioned(
        // read the size of the target point from listAW
        height: listAW[counterTargetHit].wValue.toDouble(),
        width: listAW[counterTargetHit].wValue.toDouble(),

        child: FloatingActionButton(
          backgroundColor: Colors.amber,
          child: Text("TARGET"),
          onPressed: () {
            if (counterTargetHit < 11) {
              setState(() {
                counterTargetHit++;
                topRandom = Random().nextInt(350).toDouble() +
                    250.0; // Make a new random position.
                leftRandom = Random().nextInt(320).toDouble();
                Target = findTarget(100, topRandom, leftRandom);
                // print("topRandom is $topRandom");
                // print("leftRandom is $leftRandom");
                print("Target is on $Target"); // just to track what's going on.

                //to capture the time that user hit the target (should be save in a file)
                DateTime now = DateTime.now();
                print('@@@@@@Target point is hit at this time: ' +
                    now.toString());

                Experiment().writeContent('Target hit: ' + now.toString());

                //just to see howmany time user hit the target
                print('***Target hit this many time: $counterTargetHit');
              });
            } else {
              //after 90 times (for now 12 times) it should back to home to select another finger
              Navigator.pop(context);
            }
          },
        ),
        top: topRandom, // used those random numbers here.
        left: leftRandom,
      );
}

class StartPoint extends StatefulWidget {
  int buttonHeight = 50;
  StartPoint(targetSize) {
    buttonHeight = targetSize;
  }
  @override
  _StartPointState createState() => _StartPointState();
}

class _StartPointState extends State<StartPoint> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: widget.buttonHeight.toDouble(),
      color: Colors.red[800],
      shape: CircleBorder(),
      onPressed: () {
        setState(() {
          StartPoint(200);
          //to capture the time that user hit the start (should be save in a file)
          DateTime now = DateTime.now();
          Experiment().writeContent('Start hit: ' + now.toString());
          print('#####Start point is hit at this time: ' + now.toString());
        });
      },
      child: Text('START'),
    );
  }
}

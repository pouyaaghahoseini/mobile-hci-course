import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Fitts Law Experiment',
    home: Home(),
    // routes: {
    //   '/': (context) => Home(),
    //   '/home': (context) =>
    // },
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Fitts Law Experiment'),
      ),
      body: Center(
          child: Text(
        'Please use your index finger to hit the buttons\n First select the start then the target \n Hit GO to start, Thanks!',
        style: TextStyle(fontSize: 15),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecondRoute()),
          );
        },
        child: Text('GO'),
      ),
    );
  }
}

class SecondRoute extends StatefulWidget {
  @override
  _SecondRouteState createState() => _SecondRouteState();
}

class _SecondRouteState extends State<SecondRoute> {
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
          // Positioned(
          //   child: FloatingActionButton(
          //     backgroundColor: Colors.amber,
          //     child: Text("A"),
          //     onPressed: () {
          //       setState(() {
          //         topRandom = Random().nextInt(350).toDouble() + 250.0;
          //         leftRandom = Random().nextInt(320).toDouble();
          //         print("topRandom is $topRandom");
          //         print("leftRandom is $leftRandom");
          //       });
          //     },
          //   ),
          //   top: topRandom,
          //   left: leftRandom,
          // ),
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
    // return MaterialButton(
    //   height: 50,
    //   color: Colors.red[400],
    //   shape: CircleBorder(),
    //   onPressed: () {
    //     StartingPoint();
    //   },
    //   child: Text('START'),
    // );
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
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => SecondRoute()),
        // );
      },
      child: Text('TARGET'),
    );
  }
}

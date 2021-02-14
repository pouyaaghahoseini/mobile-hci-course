import 'dart:math';

import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: 'Fitts Law Experiment',
    home: FirstRoute(),
  ));
}

class FirstRoute extends StatefulWidget {
  @override
  _FirstRouteState createState() => _FirstRouteState();
}

class _FirstRouteState extends State<FirstRoute> {
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
  var topRandom = Random();
  var leftRandom = Random();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Experiment Started!"),
      ),
      body: Stack(
        children: [
          Positioned(
            child: StartingPoint(),
            top: topRandom.nextInt(680).toDouble(),
            left: topRandom.nextInt(320).toDouble(),
          ),
          Positioned(
            child: TargetPoint(200),
            top: 100,
            left: 50,
          )
        ],
      ),
    );
  }
}

class StartingPoint extends StatefulWidget {
  @override
  _StartingPointState createState() => _StartingPointState();
}

class _StartingPointState extends State<StartingPoint> {
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      height: 50,
      color: Colors.red[400],
      shape: CircleBorder(),
      onPressed: () {
        null;
      },
      child: Text('START'),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SecondRoute()),
        );
      },
      child: Text('TARGET'),
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';

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
          Navigator.pushNamed(context, '/experiment');
        },
        child: Text('GO'),
      ),
    );
  }
}

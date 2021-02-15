import 'dart:math';
import 'package:flutter/material.dart';
import 'package:assignment1/pages/home.dart';
import 'package:assignment1/pages/experiment.dart';

void main() {
  runApp(MaterialApp(
    title: 'Fitts Law Experiment',
    routes: {
      '/': (context) => Home(),
      '/experiment': (context) => Experiment(),
    },
  ));
}

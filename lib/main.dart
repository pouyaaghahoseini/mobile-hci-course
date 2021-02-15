import 'dart:math';
import 'package:flutter/material.dart';
import 'package:first_assignment_edition3/pages/home.dart'; //the address of home page code.
import 'package:first_assignment_edition3/pages/experiment.dart'; // all the codes of Experiment page is here.

void main() {
  runApp(MaterialApp(
    title: 'Fitts Law Experiment',
    routes: {
      '/': (context) => Home(), // The page that application starts with
      '/experiment': (context) =>
          Experiment(), // the other page which is the Experiment
    },
  ));
}

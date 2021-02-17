import 'package:flutter/material.dart';
import 'package:fitts_law_experiment/pages/home.dart'; //the address of home page code.
import 'package:fitts_law_experiment/pages/experiment.dart'; // all the codes of Experiment page is here.

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

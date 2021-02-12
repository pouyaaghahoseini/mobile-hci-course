import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: Home()));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("My First App"),
      //   centerTitle: true,
      //   backgroundColor: Colors.red[600],
      // ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            children: [Text("Hello There")],
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.cyan,
            child: Text('One'),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.amber,
            child: Text('Two'),
          ),
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.pinkAccent,
            child: Text('Three'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _pressed = !_pressed;
          });
        },
        child: Text("Click!"),
        backgroundColor: _pressed ? Colors.blue : Colors.red,
      ),
    );
  }
}

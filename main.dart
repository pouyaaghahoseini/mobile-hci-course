import 'package:flutter/material.dart';
import 'Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Drawing page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint(
        painter: Sketcher(points),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: menuSelected,
            itemBuilder: (BuildContext context) {
              return Constants.choices.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          )
        ],
      ),
      body: GestureDetector(
        onPanUpdate: (DragUpdateDetails details) {
          //when the user touch the screen and move
          setState(() {
            RenderBox box = context.findRenderObject(); //finds the scaffold
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(0.0, -(AppBar().preferredSize.height + 30));
            //reduce the status bar and appbar height from it (the "30" might be different in your device)

            points = List.from(points)
              ..add(point); //add the points when user drag in screen
          });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            points.add(null);
            //points.clear();
          });
        },
        child: sketchArea,
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'clear screen',
        backgroundColor: Colors.red,
        child: Icon(Icons.refresh),
        onPressed: () {
          setState(() {
            points.clear();
          });
        },
      ),
    );
  }

  void menuSelected(String choice) {
    // when popup menu is selected

    switch (choice) {
      case Constants.freeDraw:
        {
          print("#### Free Draw has been selected ####");
          //points.clear();
        }
        break;

      case Constants.line:
        {
          print("#### Line has been selected ####");
        }
        break;

      case Constants.circle:
        {
          print("#### Circle has been selected ####");
        }
        break;

      case Constants.rectangle:
        {
          print("#### Rectangle has been selected ####");
        }
        break;
      case Constants.triangle:
        {
          print("#### Triangle has been selected ####");
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  } //end of the menuSelected method

}

class Sketcher extends CustomPainter {
  final List<Offset> points;
  Sketcher(this.points);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black //seting the color of the drawing
      ..strokeCap = StrokeCap.round //the shape of a single dot (single touch)
      ..strokeWidth = 4.0; // the width of a single dot (single touch)

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }
  }
}

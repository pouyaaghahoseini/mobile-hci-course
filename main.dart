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
  Offset
      firstPoint; //for remembering the first point of the line (for line mode)
  String mode =
      "FreeDraw"; //for passing the mode selected from popup menu to others

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50], //background color of the paint area
      child: CustomPaint(
        painter: Sketcher(points, mode),
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
        onPanDown: (DragDownDetails details) {
          setState(() {
            RenderBox box2 = context.findRenderObject(); //finds the scaffold
            Offset point2 = box2.globalToLocal(details.globalPosition);
            point2 =
                point2.translate(0.0, -(AppBar().preferredSize.height + 30));
            firstPoint = point2; //for the first point of the line mode
            points = List.from(points)..add(point2);
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          //when the user touch the screen and move
          setState(() {
            RenderBox box = context.findRenderObject(); //finds the scaffold
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(0.0, -(AppBar().preferredSize.height + 30));

            points = List.from(points)
              ..add(point); //add the points when user drag in screen
          });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            if (mode == "Line") {
              Offset lastPoint =
                  points.last; //storing the last point for drawing the line
              points = List.from(points)..add(firstPoint);
              points = List.from(points)..add(lastPoint);
              points.add(null);
              int firstInx = List.from(points).indexOf(firstPoint);
              int lastindx = List.from(points).lastIndexOf(firstPoint);

              points.removeRange(
                  firstInx, lastindx); //erasing the line that use drew

            } else if (mode == "FreeDraw") {
              points.add(null);
            }
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
          mode = "FreeDraw";
          print("#### Free Draw has been selected ####");
        }
        break;

      case Constants.line:
        {
          mode = "Line";
          print("#### Line has been selected ####");
        }
        break;

      case Constants.circle:
        {
          mode = "Circle";
          print("#### Circle has been selected ####");
        }
        break;

      case Constants.rectangle:
        {
          mode = "Rectangle";
          print("#### Rectangle has been selected ####");
        }
        break;
      case Constants.triangle:
        {
          mode = "Triangle";
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
  String mode;
  Sketcher(this.points, this.mode);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return oldDelegate.points != points;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black //seting the color of the drawing
      ..strokeCap = StrokeCap.round //the shape of a single dot (single touch)
      ..strokeWidth = 4.0; // the width of a single dot (single touch)

    switch (mode) {
      case "FreeDraw":
        {
          for (int i = 0; i < points.length - 1; i++) {
            if (points[i] != null && points[i + 1] != null) {
              canvas.drawLine(points[i], points[i + 1], paint);
            }
          }
        }
        break;
      case "Line":
        {
          for (int i = 0; i < points.length - 1; i++) {
            if (points[i] != null && points[i + 1] != null) {
              canvas.drawLine(points[i], points[i + 1], paint);
            }
          }
        }
        break;

      case "Circle":
        {}
        break;

      case "Rectangle":
        {}
        break;
      case "Triangle":
        {}
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }
}

import 'dart:ui';

import 'package:flutter/material.dart';
import 'Constants.dart';
import 'dart:math';

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
  List<Offset> pointsCircle = <Offset>[]; //for the center of the circle
  List<Offset> pointsTriangle = <Offset>[];
  List<double> radiusCircle = <double>[]; //for radius of the circle
  List<Offset> pointsRectangle =
      <Offset>[]; //for the upleft point of the rectangle
  List<Size> sizeRectangle = <Size>[]; //for the size of the rectangle
  List<Offset> pointsTemp =
      <Offset>[]; //for remembering the last thing that user draw
  Offset firstPoint;
  String mode = "FreeDraw"; //for passing the mode from popupmenu to others

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50], //background color
      child: CustomPaint(
        // size: Size(500, 500),
        painter: Sketcher(points, pointsCircle, radiusCircle, pointsRectangle,
            sizeRectangle, pointsTriangle, mode),
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
          points.add(null);
          setState(() {
            pointsTemp.clear(); //the previous drawing should be clear

            RenderBox box2 = context.findRenderObject(); //finds the scaffold
            Offset point2 = box2.globalToLocal(details.globalPosition);
            point2 =
                point2.translate(0.0, -(AppBar().preferredSize.height + 30));
            firstPoint =
                point2; //for finding the first point that user touch the screen
            points = List.from(points)
              ..add(point2); //add the points when user drag in screen
          });
        },
        onPanUpdate: (DragUpdateDetails details) {
          //when the user touch the screen and move
          setState(() {
            RenderBox box = context.findRenderObject(); //finds the scaffold
            Offset point = box.globalToLocal(details.globalPosition);
            point = point.translate(0.0, -(AppBar().preferredSize.height + 30));

            pointsTemp = List.from(pointsTemp)..add(point);
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

              int firstInx = List.from(points).indexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(firstPoint);

              points.removeRange(firstInx, lastInx); //removing what uset drew
            } else if (mode == "Circle") {
              Offset lastPoint = points.last;
              int firstInx = List.from(points).lastIndexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(lastPoint);
              points.removeRange(
                  firstInx, lastInx); //removing what the user drew
              findCircleCenterRadius(); //adding the circle center and radius to the right lists
            } else if (mode == "Rectangle") {
              Offset lastPoint = points.last;
              int firstInx = List.from(points).lastIndexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(lastPoint);
              points.removeRange(
                  firstInx, lastInx); //removing what the user drew
              findRectanglePointSize();
            } else if (mode == "Triangle") {
              Offset lastPoint = points.last;
              int firstInx = List.from(points).lastIndexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(lastPoint);
              points.removeRange(
                  firstInx, lastInx); //removing what the user drew
              findTriangle();
            } else if (mode == "FreeDraw") {}
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
            pointsCircle.clear();
            radiusCircle.clear();
            pointsRectangle.clear();
            pointsTriangle.clear();
            sizeRectangle.clear();
          });
        },
      ),
    );
  }

  findCircleCenterRadius() {
    double maxX = 0, maxY = 0, minX = 10000, minY = 10000;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        maxX = max(pointsTemp[i].dx, maxX);
        maxY = max(pointsTemp[i].dy, maxY);
        minX = min(pointsTemp[i].dx, minX);
        minY = min(pointsTemp[i].dy, minY);
      }
    }
    pointsCircle = List.from(pointsCircle)
      ..add(Offset(minX + ((maxX - minX) / 2), minY + ((maxY - minY) / 2)));
    pointsCircle.add(null);
    radiusCircle = List.from(radiusCircle)
      ..add(max((maxX - minX) / 2, (maxY - minY) / 2));
    radiusCircle.add(null);
  }

  findRectanglePointSize() {
    double maxX = 0, maxY = 0, minX = 10000, minY = 10000;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        maxX = max(pointsTemp[i].dx, maxX);
        maxY = max(pointsTemp[i].dy, maxY);
        minX = min(pointsTemp[i].dx, minX);
        minY = min(pointsTemp[i].dy, minY);
      }
    }
    pointsRectangle = List.from(pointsRectangle)..add(Offset(minX, minY));
    pointsRectangle.add(null);
    sizeRectangle = List.from(sizeRectangle)
      ..add(Size(maxX - minX, maxY - minY));
    sizeRectangle.add(null);
  }

  findTriangle() {
    double maxX = 0, maxY = 0, minX = 10000, minY = 10000;
    Offset a, b, c, d;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        maxX = max(pointsTemp[i].dx, maxX);
        maxY = max(pointsTemp[i].dy, maxY);
        minX = min(pointsTemp[i].dx, minX);
        minY = min(pointsTemp[i].dy, minY);
      }
    }
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        if (pointsTemp[i].dx == minX) {
          a = pointsTemp[i];
        }
        if (pointsTemp[i].dx == maxX) {
          b = pointsTemp[i];
        }
        if (pointsTemp[i].dy == minY) {
          c = pointsTemp[i];
        }
        if (pointsTemp[i].dy == maxY) {
          d = pointsTemp[i];
        }
      }
    }
    if (!pointsTriangle.contains(a)) {
      pointsTriangle = List.from(pointsTriangle)..add(a);
    }
    if (!pointsTriangle.contains(b)) {
      pointsTriangle = List.from(pointsTriangle)..add(b);
    }
    if (!pointsTriangle.contains(c)) {
      pointsTriangle = List.from(pointsTriangle)..add(c);
    }
    if (!pointsTriangle.contains(d)) {
      pointsTriangle = List.from(pointsTriangle)..add(d);
    }
    pointsTriangle.add(null);
    print(pointsTriangle);
  }

  void menuSelected(String choice) {
    // when popup menu is selected
    mode = choice.toString();
  }
}

class Sketcher extends CustomPainter {
  final List<Offset> points;
  final List<Offset> pointsCircle;
  final List<double> radiusCircle;
  final List<Offset> pointsRectangle;
  final List<Size> sizeRectangle;
  final List<Offset> pointsTriangle;

  String mode;
  Sketcher(this.points, this.pointsCircle, this.radiusCircle,
      this.pointsRectangle, this.sizeRectangle, this.pointsTriangle, this.mode);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return (oldDelegate.points != points ||
            oldDelegate.pointsCircle != pointsCircle ||
            oldDelegate.pointsRectangle != pointsRectangle) ||
        oldDelegate.pointsTriangle != pointsTriangle;
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black //seting the color of the drawing
      ..strokeCap = StrokeCap.round //the shape of a single dot (single touch)
      ..strokeWidth = 4.0 // the width of a single dot (single touch)
      ..style = PaintingStyle.stroke; //to make the shaped hollow

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    for (int i = 0; i < pointsCircle.length - 1; i++) {
      if (pointsCircle[i] != null && radiusCircle[i] != null) {
        canvas.drawCircle(pointsCircle[i], radiusCircle[i], paint);
      }
    }

    for (int i = 0; i < pointsRectangle.length - 1; i++) {
      if (pointsRectangle[i] != null && sizeRectangle[i] != null) {
        canvas.drawRect(pointsRectangle[i] & sizeRectangle[i], paint);
      }
    }
    // for (int i = 0; i < pointsTriangle.length - 1; i++) {
    //   if (pointsTriangle[i] != null) {
    //     canvas.drawPoints(PointMode.points, pointsTriangle, paint);
    //   }
    // }
    var path = Path();
    path.addPolygon([
      pointsTriangle[0],
      pointsTriangle[1],
      pointsTriangle[2],
      pointsTriangle[3]
    ], true);
    canvas.drawPath(path, paint);
  }
}

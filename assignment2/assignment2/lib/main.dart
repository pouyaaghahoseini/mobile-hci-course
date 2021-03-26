import 'dart:ui';
import 'package:flutter/material.dart';
import 'Constants.dart';
import 'dart:math';

class Triangle {
  Offset v1;
  Offset v2;
  Offset v3;
  void disp() {
    print("V1: $v1");
    print("V2: $v2");
    print("V3: $v3");
  }
}

class Rectangle {
  Offset v1;
  Offset v2;
  Offset v3;
  Offset v4;
  void disp() {
    print("V1: $v1");
    print("V2: $v2");
    print("V3: $v3");
    print("V4: $v4");
  }
}

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
  List<Triangle> allTriangles = <Triangle>[];
  List<Rectangle> allRectangles = <Rectangle>[];
  List<double> radiusCircle = <double>[]; //for radius of the circle
  //List<Offset> pointsRectangle =
  //  <Offset>[]; //for the upleft point of the rectangle
  //List<Size> sizeRectangle = <Size>[]; //for the size of the rectangle
  List<Offset> pointsTemp =
      <Offset>[]; //for remembering the last thing that user draw
  Offset firstPoint;
  String mode = "FreeDraw"; //for passing the mode from popupmenu to others
  List<Color> freeLineColors =
      <Color>[]; // for storing the color of the line and free draw
  List<Color> circleColor = <Color>[]; // for storing the color of the circle
  List<Color> rectangleColor =
      <Color>[]; // for storing the color of the Rectangle
  List<Color> triangleColor =
      <Color>[]; // for storing the color of the Triangle
  Color selectedColor = Colors.black;
  bool fillOutline = false; //outline
  List<bool> circleFill = <bool>[];
  List<bool> rectFill = <bool>[];
  List<bool> triFill = <bool>[];

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(4.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50], //background color
      child: CustomPaint(
        // size: Size(600, 800),
        painter: Sketcher(
            points,
            pointsCircle,
            radiusCircle,
            /*pointsRectangle,*/
            /* sizeRectangle,*/
            allRectangles,
            allTriangles,
            freeLineColors,
            circleColor,
            circleFill,
            rectangleColor,
            rectFill,
            triangleColor,
            triFill,
            mode),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        //title: Text(widget.title),
        actions: <Widget>[
          ButtonTheme(
              minWidth: 20,
              child: RaisedButton(
                onPressed: () {
                  fillOutline = false;
                },
                color: Colors.green[200],
                textColor: Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Text("Outline"),
              )),
          ButtonTheme(
              minWidth: 20,
              child: RaisedButton(
                onPressed: () {
                  fillOutline = true;
                },
                color: Colors.green[400],
                textColor: Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                child: Text("Filled"),
              )),
          ButtonTheme(
              minWidth: 20,
              child: RaisedButton(
                onPressed: () {
                  selectedColor = Colors.red;
                },
                color: Colors.red,
                // textColor: Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                // child: Text("Red"),
              )),
          ButtonTheme(
              minWidth: 20,
              child: RaisedButton(
                onPressed: () {
                  selectedColor = Colors.purple;
                },
                color: Colors.purple,
                //textColor: Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                // child: Text("Purple"),
              )),
          ButtonTheme(
              minWidth: 20,
              child: RaisedButton(
                onPressed: () {
                  selectedColor = Colors.yellow;
                },
                color: Colors.yellow,
                //textColor: Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                // child: Text("Yellow"),
              )),
          ButtonTheme(
              minWidth: 20,
              child: RaisedButton(
                onPressed: () {
                  selectedColor = Colors.black;
                },
                color: Colors.black,
                //textColor: Colors.black,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0),
                ),
                // child: Text("Black"),
              )),
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
          freeLineColors.add(null);
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
            freeLineColors = List.from(freeLineColors)..add(selectedColor);
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
            freeLineColors = List.from(freeLineColors)..add(selectedColor);
          });
        },
        onPanEnd: (DragEndDetails details) {
          setState(() {
            if (mode == "Line") {
              Offset lastPoint =
                  points.last; //storing the last point for drawing the line
              points = List.from(points)..add(firstPoint);
              points = List.from(points)..add(lastPoint);
              freeLineColors = List.from(freeLineColors)..add(selectedColor);
              freeLineColors = List.from(freeLineColors)..add(selectedColor);
              int firstInx = List.from(points).indexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(firstPoint);

              points.removeRange(firstInx, lastInx); //removing what uset drew
              freeLineColors.removeRange(firstInx, lastInx);
            } else if (mode == "Circle") {
              Offset lastPoint = points.last;
              int firstInx = List.from(points).lastIndexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(lastPoint);
              points.removeRange(
                  firstInx, lastInx); //removing what the user drew
              freeLineColors.removeRange(firstInx, lastInx);
              findCircleCenterRadius(); //adding the circle center and radius to the right lists
            } else if (mode == "Rectangle") {
              Offset lastPoint = points.last;
              int firstInx = List.from(points).lastIndexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(lastPoint);
              points.removeRange(
                  firstInx, lastInx); //removing what the user drew
              freeLineColors.removeRange(firstInx, lastInx);
              // findRectanglePointSize();
              findRectangle();
            } else if (mode == "Triangle") {
              Offset lastPoint = points.last;
              int firstInx = List.from(points).lastIndexOf(firstPoint);
              int lastInx = List.from(points).lastIndexOf(lastPoint);
              points.removeRange(
                  firstInx, lastInx); //removing what the user drew
              freeLineColors.removeRange(firstInx, lastInx);
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
            /*pointsRectangle.clear();*/
            allRectangles.clear();
            allTriangles.clear();
            freeLineColors.clear();
            circleColor.clear();
            circleFill.clear();
            rectangleColor.clear();
            rectFill.clear();
            triangleColor.clear();
            triFill.clear();
            //sizeRectangle.clear();
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
    circleColor = List.from(circleColor)..add(selectedColor);
    circleColor.add(null);
    circleFill = List.from(circleFill)..add(fillOutline);
    circleFill.add(null);
  }

/*
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
*/
  findRectangle() {
    Offset v1, v2, v3, v4;
    double maxDist = 0.0;
    for (int i = 1; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        if ((pointsTemp[0] - pointsTemp[i]).distance >= maxDist) {
          maxDist = (pointsTemp[0] - pointsTemp[i]).distance;
          v1 = pointsTemp[i];
        }
      }
    }
    maxDist = 0.0;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        if ((v1 - pointsTemp[i]).distance >= maxDist) {
          maxDist = (v1 - pointsTemp[i]).distance;
          v2 = pointsTemp[i];
        }
      }
    }
    maxDist = 0.0;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        Offset C = pointsTemp[i];
        double d = ((v2.dx - v1.dx) * (v1.dy - C.dy) -
                (v1.dx - C.dx) * (v2.dy - v1.dy))
            .abs();
        double rd = d / ((v2 - v1).distance);
        if ((rd >= maxDist)) {
          maxDist = rd;
          v3 = pointsTemp[i];
        }
      }
    }
    maxDist = 0.0;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        if ((v3 - pointsTemp[i]).distance >= maxDist) {
          maxDist = (v3 - pointsTemp[i]).distance;
          v4 = pointsTemp[i];
        }
      }
    }
    Rectangle r = new Rectangle();
    r.v1 = v1;
    r.v2 = v2;
    r.v3 = v3;
    r.v4 = v4;
    r.disp();
    double dist = (v2 - v3).distance;
    double dir = (v1 - v3).direction + pi / 2;
    print(dir);
    r.v2 = Offset((v3.dx + dist * cos(dir)), (v3.dy + dist * sin(dir)));
    r.v4 = Offset((v1.dx + dist * cos(dir)), (v1.dy + dist * sin(dir)));

    r.disp();
    allRectangles = List.from(allRectangles)..add(r);
    allRectangles.add(null);
    rectangleColor = List.from(rectangleColor)..add(selectedColor);
    rectangleColor.add(null);
    rectFill = List.from(rectFill)..add(fillOutline);
    rectFill.add(null);
  }

  findTriangle() {
    Offset v1, v2, v3;
    double maxDist = 0.0;
    for (int i = 1; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        if ((pointsTemp[0] - pointsTemp[i]).distance >= maxDist) {
          maxDist = (pointsTemp[0] - pointsTemp[i]).distance;
          v1 = pointsTemp[i];
        }
      }
    }
    maxDist = 0.0;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        if ((v1 - pointsTemp[i]).distance >= maxDist) {
          maxDist = (v1 - pointsTemp[i]).distance;
          v2 = pointsTemp[i];
        }
      }
    }
    maxDist = 0.0;
    for (int i = 0; i < pointsTemp.length - 1; i++) {
      if (pointsTemp[i] != null) {
        Offset C = pointsTemp[i];
        double d = ((v2.dx - v1.dx) * (v1.dy - C.dy) -
                (v1.dx - C.dx) * (v2.dy - v1.dy))
            .abs();
        double rd = d / ((v2 - v1).distance);
        if ((rd >= maxDist)) {
          maxDist = rd;
          v3 = pointsTemp[i];
        }
      }
    }
    Triangle t = new Triangle();
    t.v1 = v1;
    t.v2 = v2;
    t.v3 = v3;
    t.disp();
    allTriangles = List.from(allTriangles)..add(t);
    allTriangles.add(null);
    triangleColor = List.from(triangleColor)..add(selectedColor);
    triangleColor.add(null);
    triFill = List.from(triFill)..add(fillOutline);
    triFill.add(null);
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
  // final List<Offset> pointsRectangle;
  //final List<Size> sizeRectangle;
  final List<Rectangle> allRectangles;
  final List<Triangle> allTriangles;
  final List<Color> freeLineColors;
  final List<Color> circleColor;
  final List<bool> circleFill;
  final List<Color> rectangleColor;
  final List<bool> rectFill;
  final List<Color> triangleColor;
  final List<bool> triFill;

  String mode;
  Sketcher(
      this.points,
      this.pointsCircle,
      this.radiusCircle,
      // this.pointsRectangle,
      // this.sizeRectangle,
      this.allRectangles,
      this.allTriangles,
      this.freeLineColors,
      this.circleColor,
      this.circleFill,
      this.rectangleColor,
      this.rectFill,
      this.triangleColor,
      this.triFill,
      this.mode);

  @override
  bool shouldRepaint(Sketcher oldDelegate) {
    return (oldDelegate.points != points ||
        oldDelegate.pointsCircle != pointsCircle ||
        /*oldDelegate.pointsRectangle != pointsRectangle ||*/
        oldDelegate.allRectangles != allRectangles ||
        oldDelegate.allTriangles != allTriangles);
  }

  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black //seting the color of the drawing
      ..strokeCap = StrokeCap.round //the shape of a single dot (single touch)
      ..strokeWidth = 4.0 // the width of a single dot (single touch)
      ..style = PaintingStyle.stroke; //to make the shaped hollow

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null &&
          points[i + 1] != null &&
          freeLineColors[i] != null) {
        paint = Paint()
          ..color = freeLineColors[i]
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 4.0
          ..style = PaintingStyle.stroke;
        canvas.drawLine(points[i], points[i + 1], paint);
      }
    }

    for (int i = 0; i < pointsCircle.length - 1; i++) {
      if (pointsCircle[i] != null &&
          radiusCircle[i] != null &&
          circleColor[i] != null &&
          circleFill[i] != null) {
        if (circleFill[i]) {
          paint = Paint()
            ..color = circleColor[i]
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4.0
            ..style = PaintingStyle.fill;
          //print(circleColor[i]);
          canvas.drawCircle(pointsCircle[i], radiusCircle[i], paint);
        } else {
          paint = Paint()
            ..color = circleColor[i]
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke;
          //print(circleColor[i]);
          canvas.drawCircle(pointsCircle[i], radiusCircle[i], paint);
        }
      }
    }
    /*
    for (int i = 0; i < pointsRectangle.length - 1; i++) {
      if (pointsRectangle[i] != null && sizeRectangle[i] != null) {
        canvas.drawRect(pointsRectangle[i] & sizeRectangle[i], paint);
      }
    }
    */
    print("AllRectangles: $allRectangles");
    for (int i = 0; i < allRectangles.length - 1; i++) {
      if (allRectangles[i] != null &&
          rectangleColor[i] != null &&
          rectFill[i] != null) {
        var rectanglePath = Path();
        rectanglePath.addPolygon([
          allRectangles[i].v1,
          allRectangles[i].v3,
          allRectangles[i].v2,
          allRectangles[i].v4
        ], true);
        if (rectFill[i]) {
          paint = Paint()
            ..color = rectangleColor[i]
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4.0
            ..style = PaintingStyle.fill;
          canvas.drawPath(rectanglePath, paint);
        } else {
          paint = Paint()
            ..color = rectangleColor[i]
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke;
          canvas.drawPath(rectanglePath, paint);
        }
      }
    }

    print("AllTriangles: $allTriangles");
    for (int i = 0; i < allTriangles.length - 1; i++) {
      if (allTriangles[i] != null &&
          triangleColor[i] != null &&
          triFill[i] != null) {
        var trianglePath = Path();
        trianglePath.addPolygon(
            [allTriangles[i].v1, allTriangles[i].v2, allTriangles[i].v3], true);
        if (triFill[i]) {
          paint = Paint()
            ..color = triangleColor[i]
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4.0
            ..style = PaintingStyle.fill;
          canvas.drawPath(trianglePath, paint);
        } else {
          paint = Paint()
            ..color = triangleColor[i]
            ..strokeCap = StrokeCap.round
            ..strokeWidth = 4.0
            ..style = PaintingStyle.stroke;
          canvas.drawPath(trianglePath, paint);
        }
      }
    }
  }
}

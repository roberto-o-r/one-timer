import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() => runApp(MaterialApp(
      home: OneTimerApp(),
    ));

class OneTimerApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OneTimerState();
}

class OneTimerState extends State<OneTimerApp> with TickerProviderStateMixin {
  AnimationController controller;

  String get timerString {
    Duration duration = controller.duration * controller.value;
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Align(
                alignment: FractionalOffset.center,
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: Stack(
                    children: <Widget>[
                      Positioned.fill(
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (BuildContext context, Widget child) {
                            return CustomPaint(
                              painter: TimerPainter(
                                  animation: controller,
                                  backgroundColor: Colors.white,
                                  color: Colors.pink),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align()
          ],
        ),
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final Animation<double> animation;
  final Color backgroundColor, color;

  TimerPainter({this.animation, this.backgroundColor, this.color})
      : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 20.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value ||
        color != oldDelegate.color ||
        backgroundColor != oldDelegate.backgroundColor;
  }
}

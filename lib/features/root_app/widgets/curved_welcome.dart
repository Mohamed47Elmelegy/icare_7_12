import 'package:flutter/material.dart';

class ClippingApp extends StatelessWidget {
  const ClippingApp({super.key});
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return CustomPaint(
      size: Size(
          width,
          (width * 0.5833333333333334)
              .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
      painter: RPSCustomPainter(),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paintFill0 = Paint()
      ..color = const Color.fromARGB(255, 255, 255, 255)
      ..style = PaintingStyle.fill
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    Path path_0 = Path();
    path_0.moveTo(size.width * 1.0008333, size.height * 0.3557143);
    path_0.lineTo(size.width * 0.7091667, size.height * 0.3914286);
    path_0.lineTo(size.width * 0.6216667, size.height * 0.4142857);
    path_0.lineTo(size.width * 0.2100000, size.height * 0.4614286);
    path_0.lineTo(size.width * 0.1066667, size.height * 0.4671429);
    path_0.lineTo(size.width * 0.0575000, size.height * 0.4757143);
    path_0.lineTo(size.width * 0.0166667, size.height * 0.4771429);
    path_0.lineTo(size.width * 0.0016667, size.height * 0.4785714);
    path_0.lineTo(size.width * 0.0008333, size.height * 0.8571429);
    path_0.lineTo(size.width * 0.3183333, size.height * 0.8000000);
    path_0.lineTo(size.width * 0.5566667, size.height * 0.7485714);
    path_0.lineTo(size.width * 0.7666667, size.height * 0.7085714);
    path_0.lineTo(size.width * 0.8600000, size.height * 0.6971429);
    path_0.lineTo(size.width * 0.9666667, size.height * 0.6585714);
    path_0.lineTo(size.width * 0.9975000, size.height * 0.6500000);

    canvas.drawPath(path_0, paintFill0);

    // Layer 1

    Paint paintStroke = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.00
      ..strokeCap = StrokeCap.butt
      ..strokeJoin = StrokeJoin.miter;

    canvas.drawPath(path_0, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

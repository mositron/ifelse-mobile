import 'package:flutter/material.dart';
import 'util.dart';

Gradient getGradient(dynamic obj) {
  List<Color> colors = [];
  if ((obj != null) && (obj is! List)) {
    int gradient = getInt(obj['gradient']);
    if (gradient != 5) {
      if ((obj['color1'] != null) && (obj['color1'].toString().isNotEmpty)) {
        colors.add(getColor(obj['color1']));
      }
      if (gradient > 1) {
        if ((obj['color2'] != null) && (obj['color2'].toString().isNotEmpty)) {
          colors.add(getColor(obj['color2']));
        }
      }
      if (colors.length == 1) {
        colors.add(colors[0]);
      }
      if (colors.length == 2) {
        AlignmentGeometry begin = Alignment.bottomCenter,
          end = Alignment.topCenter;
        switch (getInt(obj['range'])) {
          case 45:
            begin = Alignment.bottomLeft;
            end = Alignment.topRight;
            break;
          case 90:
            begin = Alignment.centerLeft;
            end = Alignment.centerRight;
            break;
          case 135:
            begin = Alignment.topLeft;
            end = Alignment.bottomRight;
            break;
          case 180:
            begin = Alignment.topCenter;
            end = Alignment.bottomCenter;
            break;
          case 225:
            begin = Alignment.topRight;
            end = Alignment.bottomLeft;
            break;
          case 270:
            begin = Alignment.centerRight;
            end = Alignment.centerLeft;
            break;
          case 315:
            begin = Alignment.bottomRight;
            end = Alignment.topLeft;
            break;
            break;
        }
        return LinearGradient(colors: colors, begin: begin, end: end);
      }
    }
  }
  return null;
}


class DrawCurve extends CustomPainter {
  final dynamic obj;
  DrawCurve(this.obj);

  @override
  void paint(Canvas canvas, Size size) {
    //paint.

    List<Color> colors = [];
    if ((obj != null) && (obj is! List)) {
      int gradient = getInt(obj['gradient']);
      if (gradient == 5) {
        if ((obj['color1'] != null) && (obj['color1'].toString().isNotEmpty)) {
          colors.add(getColor(obj['color1']));
        }
        if ((obj['color2'] != null) && (obj['color2'].toString().isNotEmpty)) {
          colors.add(getColor(obj['color2']));
        }
        if(colors.length > 0) {
          double w = getDouble(obj['w'],1200),
          h = getDouble(obj['h'],200),
          x1 = (getDouble(obj['x1'],0) / 100) * w,
          y1 = (getDouble(obj['y1'],10) / 100) * h,
          cx1 = (getDouble(obj['cx1'],40) / 100) * w,
          cy1 = (getDouble(obj['cy1'],0) / 100) * h,
          x2 = (getDouble(obj['x2'],100) / 100) * w,
          y2 = (getDouble(obj['y2'],10) / 100) * h,
          cx2 = (getDouble(obj['cx2'],40) / 100) * w,
          cy2 = (getDouble(obj['cy2'],30) / 100) * h,
          c = w;
          int repeat = getInt(obj['repeat'],0);
          String valign = obj['valign'] ?? 'up';
          var rect = Offset.zero & size;
          canvas.clipRect(rect);
          if(colors.length > 1) {
            canvas.drawRect(Rect.fromLTRB(0, 0, size.width, size.height), Paint()..color = colors[1]);
          }
          var paint = Paint();
          paint.color = colors[0];
          paint.style = PaintingStyle.fill;
          
          var path = Path();
          path.moveTo(x1, y1);
          path.cubicTo(cx1, cy1, cx2, cy2, x2, y2);
          if(valign == 'down') {
            path.lineTo(x2, h);
            path.lineTo(x1, h);
          } else {
            path.lineTo(x2, 0);
            path.lineTo(x1, 0);
          }
          canvas.drawPath(path, paint);
          if((repeat == 1) && (w >= 100)) {
            while (c < size.width) {
              path.moveTo(c + x1, y1);
              path.cubicTo(c + cx1, cy1, c + cx2, cy2, c + x2, y2);
              if(valign == 'down') {
                path.lineTo(c + x2, h);
                path.lineTo(c + x1, h);
              } else {
                path.lineTo(c + x2, 0);
                path.lineTo(c + x1, 0);
              }
              canvas.drawPath(path, paint);
              c += w;
            }
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) => false;
}

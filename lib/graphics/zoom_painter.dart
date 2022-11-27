import 'package:flutter/material.dart';
import 'package:zoomscroller/graphics/drawn_stroke.dart';
import 'package:zoomscroller/model/image_layer.dart';

class ZoomPainter extends CustomPainter {
  final List<ImageLayer> imageLayers;
  final Matrix4 transform;
  final Size size;
  final List<DrawnStroke> strokes;

  ZoomPainter({
    required this.imageLayers,
    required this.transform,
    required this.size,
    required this.strokes,
  });

  @override
  void paint(Canvas canvas, _) {
    canvas.save();

    // Scale the canvas so that we work in a unit coordinate space.
    // This is important, since different devices have different resolutions!
    canvas.scale(size.width, size.height);

    // Apply the current translation, zoom and rotation.
    canvas.transform(transform.storage);

    for (var imageLayer in imageLayers) {
      final image = imageLayer.image;
      if (image == null) continue;

      canvas.save();

      final inverse = Matrix4.identity();
      inverse.copyInverse(imageLayer.transform);
      canvas.transform(inverse.storage);

      paintImage(
        canvas: canvas,
        // Note: We define each image to be a unit square, and adjust the transform accordingly.
        rect: Rect.fromLTWH(0, 0, 1, 1),
        image: image,
        fit: BoxFit.scaleDown,
        filterQuality: FilterQuality.high,
      );

      canvas.restore();
    }

    canvas.restore();

    Paint linePaint = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    for (int i = 0; i < strokes.length; ++i) {
      for (int j = 0; j < strokes[i].path.length - 1; ++j) {
        linePaint.color = strokes[i].color;
        linePaint.strokeWidth = strokes[i].width;
        canvas.drawLine(strokes[i].path[j], strokes[i].path[j + 1], linePaint);
      }
    }
  }

  @override
  bool shouldRepaint(ZoomPainter oldDelegate) {
    return true;
  }
}

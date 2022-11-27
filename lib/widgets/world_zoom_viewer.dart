import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/graphics/drawn_stroke.dart';

import 'dart:ui' as ui;

import 'package:zoomscroller/graphics/zoom_painter.dart';
import 'package:zoomscroller/model/image_layer.dart';
import 'package:zoomscroller/widgets/matrix_gesture_detector.dart';
import 'package:zoomscroller/widgets/measure_size.dart';

class WorldZoomWidget extends StatefulWidget {
  final String worldId;
  final bool inDrawingMode;

  final Function(Matrix4)? onMatrixUpdate;

  WorldZoomWidget({
    Key? key,
    required this.worldId,
    required this.inDrawingMode,
    this.onMatrixUpdate,
  }) : super(key: key);

  @override
  State<WorldZoomWidget> createState() => WorldZoomWidgetState();
}

class WorldZoomWidgetState extends State<WorldZoomWidget> {
  final List<DrawnStroke> _strokes = [];

  Color selectedColor = Colors.white;

  double selectedWidth = 10.0;

  // This is updated in realtime during a scale gesture.
  // It represents the current viewport translation, scale, and rotation.
  final _transform = Matrix4.identity();

  Size? _size;

  late StreamSubscription _sdResultSubscription;

  List<ImageLayer> _imageLayers = [];

  @override
  void initState() {
    super.initState();
    _sdResultSubscription =
        worldSyncBloc.getLayersForWorld(widget.worldId).listen(
      (layers) {
        setState(() {
          _imageLayers = layers;
        });
      },
    );
  }

  @override
  void dispose() {
    _sdResultSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget child;

    if (_size == null) {
      child = const SizedBox();
    } else {
      child = Container(
        color: const Color(0xFF221133),
        alignment: Alignment.topLeft,
        child: CustomPaint(
          painter: ZoomPainter(
            imageLayers: _imageLayers,
            size: _size!,
            transform: _transform,
            strokes: _strokes,
          ),
        ),
      );
    }

    return AspectRatio(
      aspectRatio: 1,
      child: MeasureSize(
        onChange: (size) {
          setState(() {
            this._size = size;
          });
        },
        child: MatrixGestureDetector(
          shouldRotate: !widget.inDrawingMode,
          shouldScale: !widget.inDrawingMode,
          shouldTranslate: !widget.inDrawingMode,
          onDrawStart: (position) {
            if (!widget.inDrawingMode) return;
            setState(() {
              _strokes.add(
                DrawnStroke(
                  [position],
                  selectedColor,
                  selectedWidth,
                ),
              );
            });
          },
          onDrawUpdate: (position) {
            if (!widget.inDrawingMode) return;
            setState(() {
              _strokes.last.path.add(position);
            });
          },
          onMatrixUpdate: (m) {
            setState(() {
              m.copyInto(_transform);
            });
            widget.onMatrixUpdate?.call(m);
          },
          child: child,
        ),
      ),
    );
  }

  Matrix4 getTransform() {
    return _transform.clone();
  }

  Future commitAndRasterizeStrokes(String worldId) async {
    if (_strokes.isEmpty) return;
    final image = await renderImage(_transform, null, strokesOnly: true);
    await worldSyncBloc.addLayerToWorldFromImage(
      worldId,
      image,
      _transform.clone(),
    );

    _strokes.clear();
  }

  Future<ui.Image> renderImage(
    Matrix4 transform,
    Size? size, {
    bool strokesOnly = false,
  }) async {
    // Note: Need to use the widget size for painting,
    // since the transform there uses device-specific coords.
    if (size == null) size = _size!;

    final CustomPainter painter = ZoomPainter(
      imageLayers: strokesOnly ? [] : _imageLayers,
      size: size,
      transform: transform,
      strokes: _strokes,
    );

    PictureRecorder recorder = PictureRecorder();
    Canvas canvas = Canvas(recorder);
    painter.paint(canvas, size);

    final Picture picture = recorder.endRecording();
    return await picture.toImage(size.width.toInt(), size.height.toInt());
  }
}

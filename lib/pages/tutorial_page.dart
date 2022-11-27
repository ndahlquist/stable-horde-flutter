import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zoomscroller/blocs/stable_diffusion_bloc.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/colors.dart';
import 'package:zoomscroller/model/image_layer.dart';
import 'package:zoomscroller/model/pending_sd_task.dart';
import 'package:zoomscroller/model/sd_result.dart';
import 'package:zoomscroller/pages/world_editor_page.dart';
import 'package:zoomscroller/utils/shared_prefs_helper.dart';
import 'package:zoomscroller/widgets/magic_button.dart';
import 'package:zoomscroller/widgets/timed_progress_indicator.dart';
import 'package:zoomscroller/widgets/world_zoom_viewer.dart';

class TutorialPage extends StatefulWidget {
  const TutorialPage({super.key});

  @override
  State<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends State<TutorialPage> {
  final _canvasKey = GlobalKey<WorldZoomWidgetState>();

  bool _isZoomedIn = false;
  bool _requestingDiffusion = false;
  bool _hasRequestedDiffusion = false;
  bool _diffusionComplete = false;
  bool _hasAddedLayer = false;

  String? worldId;

  @override
  void initState() {
    super.initState();
    worldSyncBloc
        .photocopyWorld('6fe4e2f8-8357-428f-85c0-f8102d7de559', tutorial: true)
        .then((value) {
      if (!mounted) return;

      setState(() {
        worldId = value;
      });

      worldSyncBloc.updateSdParameters(worldId!, "", .7);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (worldId == null) {
      return Scaffold(
        backgroundColor: zoomscrollerPurple,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: zoomscrollerPurple,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: WorldZoomWidget(
                    key: _canvasKey,
                    worldId: worldId!,
                    inDrawingMode: false,
                    onMatrixUpdate: (matrix) {
                      final isZoomed = matrix.getMaxScaleOnAxis() > 2;
                      if (isZoomed != _isZoomedIn) {
                        setState(() {
                          _isZoomedIn = isZoomed;
                        });
                      }
                    },
                  ),
                ),
                IgnorePointer(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _isZoomedIn || _hasRequestedDiffusion
                        ? null
                        : Padding(
                            padding: const EdgeInsets.all(32),
                            child: Image.asset(
                              'assets/images/pinch_tooltip.png',
                              width: 100,
                            ),
                          ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: AnimatedSwitcher(
                child: _tutorialBottomSection(),
                duration: Duration(milliseconds: 500),
                switchInCurve: Curves.easeInOut,
                switchOutCurve: Curves.easeInOut,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _tutorialBottomSection() {
    if (_hasAddedLayer) return _keepGoing();

    if (_hasRequestedDiffusion) return _explainChoices();

    if (!_isZoomedIn) return _explainZoom();

    return _explainReimagine();
  }

  Widget _explainZoom() {
    return Column(
      key: ValueKey('zoom'),
      children: [
        Spacer(),
        Text(
          'Welcome!',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Have a look around.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        SizedBox(height: 12),
        Text(
          '(Use two fingers to zoom.)',
          style: TextStyle(
            color: Colors.white.withOpacity(.8),
            fontSize: 16,
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _explainReimagine() {
    return Column(
      key: ValueKey('reimagine'),
      children: [
        Spacer(),
        Text(
          'You can reimagine anything you see.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  '"A panda at a cyberpunk night market."',
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Spacer(),
        MagicButton(
          inProgress: _requestingDiffusion,
          onTapped: () async {
            setState(() {
              _requestingDiffusion = true;
            });

            try {
              final canvas = _canvasKey.currentState;
              final image = await canvas!.renderImage(
                canvas.getTransform(),
                Size(512, 512),
              );
              await stableDiffusionBloc.requestDiffusion(
                worldId!,
                image,
                "A panda at a cyberpunk night market.",
                .7,
                canvas.getTransform(),
                numTasksToQueue: 2,
              );
            } finally {
              setState(() {
                _requestingDiffusion = false;
                _hasRequestedDiffusion = true;
              });
            }
          },
        ),
        Spacer(),
      ],
    );
  }

  Widget _explainChoices() {
    return Column(
      key: ValueKey('choices_$_diffusionComplete'),
      children: [
        Spacer(),
        Text(
          _diffusionComplete
              ? "Choose your favorite\nand remake the world."
              : "Magic takes some patience...",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        StreamBuilder<List<_ResultTuple>>(
          stream: Rx.combineLatest2<List<PendingSdTask>, List<SdResult>,
              List<_ResultTuple>>(
            stableDiffusionBloc.getPendingTaskStream(worldId!),
            stableDiffusionBloc.getSdResults(worldId!),
            (List<PendingSdTask> pendingTasks, List<SdResult> results) {
              final tuples = <_ResultTuple>[];

              if (results.length == 2) {
                setState(() {
                  _diffusionComplete = true;
                });
              }

              for (final result in results.reversed) {
                tuples.add(_ResultTuple(null, result));
              }

              for (final task in pendingTasks) {
                tuples.add(_ResultTuple(task, null));
              }

              if (tuples.length > 2) {
                tuples.removeRange(2, tuples.length);
              }

              return tuples;
            },
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox.shrink();
            }
            final data = snapshot.data!;
            return Row(
              children: [
                for (final tuple in data)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: _tupleWidget(
                        tuple,
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        Spacer(),
      ],
    );
  }

  Widget _keepGoing() {
    return Column(
      key: ValueKey('keep_going'),
      children: [
        Spacer(),
        Text(
          "Keep editing to build a world all your own.",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        Spacer(),
        FractionallySizedBox(
          widthFactor: 1,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(.8),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => WorldEditorPage(worldId: worldId!),
                ),
              );

              setHasSeenTutorial();
            },
            child: Text(
              "Continue",
              style: TextStyle(color: zoomscrollerGrey),
            ),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget _tupleWidget(_ResultTuple tuple) {
    final pendingTask = tuple.pendingTask;
    Widget child;
    if (pendingTask != null) {
      child = _pendingTaskWidget(pendingTask);
    } else {
      child = _sdImage(tuple.result!);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: AspectRatio(aspectRatio: 1, child: child),
    );
  }

  Widget _pendingTaskWidget(PendingSdTask task) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (task.imageUrl != null) ...[
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: CachedNetworkImage(
              imageUrl: task.imageUrl!,
            ),
          ),
          ColoredBox(color: Colors.black45),
        ],
        SizedBox(
          width: 100,
          child: Center(
            child: Column(
              children: [
                Spacer(),
                if (task.estimatedCompletionTime == null)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(),
                  ),
                if (task.estimatedCompletionTime != null)
                  SizedBox(
                    height: 20,
                    width: 20,
                    child: TimedProgressIndicator(
                      startTime: task.startTime!,
                      completionTime: task.estimatedCompletionTime!,
                    ),
                  ),
                SizedBox(height: 8),
                Text(
                  task.description(),
                  style: TextStyle(color: Colors.white70, fontSize: 10),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sdImage(SdResult sdResult) {
    return GestureDetector(
      onTap: () async {
        final imageLayer = ImageLayer(
          sdResult.transform,
          imageUrl: sdResult.outputImageUrl,
          prompt: sdResult.prompt,
          mutationRate: sdResult.mutationRate,
          userId: userBloc.getMyUserId()!,
        );

        await worldSyncBloc.addLayerToWorld(worldId!, imageLayer);

        setState(() {
          _hasAddedLayer = true;
        });
      },
      child: Stack(
        children: [
          if (sdResult.inputImageUrl != null)
            CachedNetworkImage(imageUrl: sdResult.inputImageUrl!),
          CachedNetworkImage(imageUrl: sdResult.outputImageUrl),
        ],
      ),
    );
  }
}

class _ResultTuple {
  PendingSdTask? pendingTask;
  SdResult? result;

  _ResultTuple(this.pendingTask, this.result);
}

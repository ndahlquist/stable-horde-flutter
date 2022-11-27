import 'dart:async';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zoomscroller/blocs/stable_diffusion_bloc.dart';
import 'package:zoomscroller/blocs/user_bloc.dart';
import 'package:zoomscroller/blocs/world_sync_bloc.dart';
import 'package:zoomscroller/model/image_layer.dart';
import 'package:zoomscroller/model/pending_sd_task.dart';
import 'package:zoomscroller/pages/prompt_edit_page.dart';
import 'package:zoomscroller/widgets/magic_button.dart';
import 'package:zoomscroller/widgets/world_zoom_viewer.dart';
import 'package:zoomscroller/model/sd_result.dart';
import 'package:zoomscroller/widgets/timed_progress_indicator.dart';

/// Page that lets a user zoom and pan around a world,
///  request new stable diffusion tasks, and composite the results.
class WorldEditorPage extends StatefulWidget {
  final String worldId;

  const WorldEditorPage({
    super.key,
    required this.worldId,
  });

  @override
  _WorldEditorPageState createState() => _WorldEditorPageState();
}

class _WorldEditorPageState extends State<WorldEditorPage> {
  final _canvasKey = GlobalKey<WorldZoomWidgetState>();

  bool _inDrawingMode = false;

  double _currentMutationRate = .8;

  bool _uploadingSdRequest = false;

  String _prompt = "";

  int _numLayers = 0;

  late StreamSubscription _sdResultSubscription;

  @override
  void initState() {
    super.initState();

    worldSyncBloc.retrieveSdParameters(widget.worldId).then((value) {
      if (value == null) return;

      if (!mounted) return;

      setState(() {
        _prompt = value.prompt;
        _currentMutationRate = value.mutationRate;
      });
    });

    _sdResultSubscription =
        worldSyncBloc.getLayersForWorld(widget.worldId).listen((layers) {
      if (!mounted) return;
      setState(() {
        _numLayers = layers.length;
      });
    });
  }

  @override
  void dispose() {
    _sdResultSubscription.cancel();
    super.dispose();
  }

  bool _shouldShowCanvas() {
    return _numLayers > 0 || _inDrawingMode;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_inDrawingMode) {
          final canvas = _canvasKey.currentState;
          canvas?.commitAndRasterizeStrokes(widget.worldId);

          setState(() {
            _inDrawingMode = false;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Color(0xFF230D49),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: _inDrawingMode ? Text('Manual Paint') : Text("ZoomScroller"),
          elevation: 0,
          actions: [
            if (!_inDrawingMode)
              IconButton(
                onPressed: () {
                  setState(() {
                    _inDrawingMode = true;
                  });
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.white.withOpacity(.8),
                ),
              ),
            _dropdownMenu(),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              AnimatedSize(
                duration: Duration(milliseconds: 500),
                reverseDuration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: SizedBox(
                  height: _shouldShowCanvas() ? null : 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: WorldZoomWidget(
                        key: _canvasKey,
                        worldId: widget.worldId,
                        inDrawingMode: _inDrawingMode,
                      ),
                    ),
                  ),
                ),
              ),
              if (!_inDrawingMode)
                Row(
                  children: [
                    if (!_inDrawingMode && _numLayers > 0)
                      StreamBuilder<bool>(
                        stream: worldSyncBloc.getPublished(widget.worldId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return const SizedBox(width: 24);
                          }

                          final currentlyPublished = snapshot.data!;

                          return IconButton(
                            icon: Icon(
                              currentlyPublished
                                  ? Icons.public
                                  : Icons.public_off,
                              color: Colors.white.withOpacity(.8),
                            ),
                            onPressed: () {
                              _togglePublish(currentlyPublished);
                            },
                          );
                        },
                      ),
                    Spacer(),
                    FutureBuilder<String?>(
                      future: worldSyncBloc
                          .getOriginalAuthorForWorld(widget.worldId),
                      builder: (context, snapshot) {
                        final displayName = snapshot.data;
                        if (displayName == null) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          'Originally by @$displayName',
                          style: TextStyle(color: Colors.white),
                        );
                      },
                    ),
                    Spacer(),
                    if (!_inDrawingMode && _numLayers > 0)
                      IconButton(
                        onPressed: () async {
                          await worldSyncBloc
                              .popTopLayerFromWorld(widget.worldId);
                          _updateThumbnail();
                        },
                        icon: Icon(
                          Icons.undo,
                          color: Colors.white.withOpacity(.8),
                        ),
                      ),
                  ],
                ),
              Expanded(
                child: _editTools(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropdownMenu() {
    return PopupMenuButton(
      icon: Icon(
        Icons.adaptive.more,
        color: Colors.white.withOpacity(.8),
      ),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text('Delete World'),
          value: 'delete',
        ),
      ],
      onSelected: (value) {
        if (value == 'delete') {
          showDialog(
            context: context,
            builder: (context2) => AlertDialog(
              title: Text('Delete World'),
              content: Text(
                'Are you sure you want to delete this world? This action cannot be undone.',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context2).pop();
                  },
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context2).pop();

                    worldSyncBloc.deleteWorld(widget.worldId);
                  },
                  child: Text('Delete'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future _togglePublish(bool currentlyPublished) async {
    if (!currentlyPublished) {
      final result = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(
              "By publishing this canvas, it'll be shared with the world and be visible on the Discover feed.\n\n"
              "Please keep it PG (I'll soon add more specific community guidelines).\n",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (result == null || !result) return;
    }

    worldSyncBloc.setPublished(
      widget.worldId,
      !currentlyPublished,
    );
  }

  Widget _editTools() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_inDrawingMode) ..._drawingTools() else ..._sdTools(),
        ],
      ),
    );
  }

  List<Widget> _drawingTools() {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: _buildColorToolbar(),
      ),
    ];
  }

  Widget _buildColorToolbar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildColorButton(Colors.red),
          _buildColorButton(Colors.orange),
          _buildColorButton(Colors.yellow),
          _buildColorButton(Colors.green),
          _buildColorButton(Colors.blue),
          _buildColorButton(Colors.indigo),
          _buildColorButton(Colors.purple),
          _buildColorButton(Colors.black),
          _buildColorButton(Colors.white),
        ],
      ),
    );
  }

  Widget _buildColorButton(Color color) {
    return Padding(
      padding: const EdgeInsets.all(2),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _canvasKey.currentState!.selectedColor = color;
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(50.0),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _sdTools() {
    String promptToShow = _prompt.trim();
    if (promptToShow.isEmpty) {
      promptToShow = "Tap here to describe what we're painting today.";
    }

    return [
      GestureDetector(
        onTap: () async {
          final newPrompt = await Navigator.of(context).push<String>(
            MaterialPageRoute(
              builder: (_) => PromptEditPage(initialText: _prompt),
            ),
          );
          if (newPrompt == null) return;
          setState(() {
            _prompt = newPrompt;
          });
          worldSyncBloc.updateSdParameters(
            widget.worldId,
            _prompt,
            _currentMutationRate,
          );
        },
        child: Padding(
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
                  promptToShow,
                  maxLines: 3,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: _prompt.isEmpty ? 16 : 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
      if (_numLayers > 0 && _prompt.isNotEmpty)
        Row(
          children: [
            SizedBox(width: 16),
            Builder(builder: (context) {
              final percent = (_currentMutationRate * 100).round();
              return Text(
                "Amount of Magic: ${percent == 100 ? "" : " "}$percent%",
                style: TextStyle(color: Colors.white),
              );
            }),
            Expanded(
              child: Slider(
                value: _currentMutationRate,
                min: .1,
                max: 1,
                divisions: 9,
                onChanged: (double value) {
                  setState(() {
                    _currentMutationRate = value;
                  });
                },
              ),
            ),
          ],
        ),
      if (_numLayers == 0) SizedBox(height: 12),
      if (_prompt.isNotEmpty)
        SizedBox(
          height: MagicButton.magicButtonSize,
          child: StreamBuilder<List<PendingSdTask>>(
            stream: stableDiffusionBloc.getPendingTaskStream(widget.worldId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }
              final pendingTasks = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pendingTasks.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: MagicButton(
                        inProgress: _uploadingSdRequest,
                        onTapped: _requestDiffusion,
                      ),
                    );
                  }
                  index -= 1;
                  return _pendingTaskWidget(pendingTasks[index]);
                },
              );
            },
          ),
        ),
      SizedBox(height: 12),
      if (_prompt.isNotEmpty)
        SizedBox(
          height: 200,
          child: StreamBuilder<List<SdResult>>(
            stream: stableDiffusionBloc.getSdResults(widget.worldId),
            builder: (context, snapshot) {
              final results = snapshot.data ?? [];
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return _sdImage(results.elementAt(index));
                },
              );
            },
          ),
        ),
      SizedBox(height: 16),
    ];
  }

  Widget _pendingTaskWidget(PendingSdTask task) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: SizedBox(
        width: MagicButton.magicButtonSize,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              if (task.imageUrl == null)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF8900B6),
                        const Color(0xFF642604),
                      ],
                    ),
                  ),
                ),
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
          ),
        ),
      ),
    );
  }

  Widget _sdImage(SdResult sdResult) {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        width: 200,
        height: 200,
        child: GestureDetector(
          onTap: () async {
            final imageLayer = ImageLayer(
              sdResult.transform,
              imageUrl: sdResult.outputImageUrl,
              prompt: sdResult.prompt,
              mutationRate: sdResult.mutationRate,
              userId: userBloc.getMyUserId()!,
            );

            await worldSyncBloc.addLayerToWorld(widget.worldId, imageLayer);

            _updateThumbnail();
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                if (sdResult.inputImageUrl != null)
                  CachedNetworkImage(imageUrl: sdResult.inputImageUrl!),
                CachedNetworkImage(imageUrl: sdResult.outputImageUrl),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _updateThumbnail() async {
    if (_numLayers == 0) {
      return;
    } else if (_numLayers == 1) {
      final layers =
          await worldSyncBloc.getLayersForWorld(widget.worldId).first;
      assert(layers.length == 1);
      final layer = layers.first;
      await worldSyncBloc.updateThumbnailFromImageUrl(
        widget.worldId,
        layer.imageUrl!,
      );
    } else {
      final canvas = _canvasKey.currentState;
      if (canvas == null) return;
      final image = await canvas.renderImage(
        Matrix4.identity(),
        Size(512, 512),
      );
      await worldSyncBloc.updateThumbnailFromImage(widget.worldId, image);
    }
  }

  void _requestDiffusion() async {
    assert(_prompt.isNotEmpty);

    setState(() {
      _uploadingSdRequest = true;
    });

    try {
      if (_numLayers == 0) {
        await stableDiffusionBloc.requestDiffusion(
          widget.worldId,
          null,
          _prompt,
          1.0,
          Matrix4.identity(),
        );
      } else {
        final canvas = _canvasKey.currentState;
        final image = await canvas!.renderImage(
          canvas.getTransform(),
          Size(512, 512),
        );
        await stableDiffusionBloc.requestDiffusion(
          widget.worldId,
          image,
          _prompt,
          _currentMutationRate,
          canvas.getTransform(),
        );
      }

      await worldSyncBloc.updateSdParameters(
        widget.worldId,
        _prompt,
        _currentMutationRate,
      );
    } catch (e) {
      final snackBar = SnackBar(
        content: Text('Error: Please try again later.'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      rethrow;
    } finally {
      setState(() {
        _uploadingSdRequest = false;
      });
    }
  }
}

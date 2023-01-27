import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/models_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_model.dart';
import 'package:stable_horde_flutter/widgets/glassmorphic_background.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class ModelChooserPage extends StatefulWidget {
  const ModelChooserPage({super.key});

  @override
  State<ModelChooserPage> createState() => _ModelChooserPageState();
}

class _ModelChooserPageState extends State<ModelChooserPage> {
  bool _isSearching = false;

  final _txtSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const GlassmorphicBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: _isSearching ? _searchField() : const Text("Models"),
            actions: [
              if (!_isSearching)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                    });
                  },
                  icon: const Icon(Icons.search),
                ),
              if (_isSearching)
                IconButton(
                  onPressed: () {
                    setState(() {
                      _txtSearchController.clear();
                      _isSearching = false;
                    });
                  },
                  icon: const Icon(Icons.close),
                ),
            ],
          ),
          body: FutureBuilder<List<StableHordeModel>>(
            future: modelsBloc.getModels(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                print(snapshot.error);
                print(snapshot.stackTrace);

                Sentry.captureException(
                  snapshot.error,
                  stackTrace: snapshot.stackTrace,
                );
              }
              var models = snapshot.data ?? [];
              if (_txtSearchController.text.isNotEmpty) {
                final searchStr = _txtSearchController.text.toLowerCase();
                models = models.where((StableHordeModel model) {
                  if (model.name.toLowerCase().contains(searchStr)) {
                    return true;
                  }
                  if (model.description.toLowerCase().contains(searchStr)) {
                    return true;
                  }
                  return false;
                }).toList();
              }

              return ListView.builder(
                itemCount: models.length,
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                itemBuilder: (context, index) {
                  final model = models[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 6,
                      horizontal: 12,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        await sharedPrefsBloc.setModel(model.name);

                        if (!mounted) return;
                        Navigator.of(context).pop();
                      },
                      child: SectionFrame(
                        padding: 8,
                        child: SizedBox(
                          height: 128,
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        model.name,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        "${model.workerCount} worker${model.workerCount == 1 ? "" : "s"}",
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontStyle: FontStyle.italic,
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Expanded(
                                        child: Text(
                                          model.description,
                                          style: const TextStyle(fontSize: 10),
                                          softWrap: true,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              AspectRatio(
                                aspectRatio: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: CachedNetworkImage(
                                    imageUrl: model.previewImageUrl,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _searchField() {
    return TextField(
      controller: _txtSearchController,
      autofocus: true,
      decoration: const InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        hintStyle: TextStyle(color: Colors.white),
        hintText: "Search",
      ),
      keyboardType: TextInputType.text,
      onChanged: (_) {
        setState(() {});
      },
    );
  }
}

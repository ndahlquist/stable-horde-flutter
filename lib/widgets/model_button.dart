import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/models_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/model/stable_horde_model.dart';
import 'package:stable_horde_flutter/pages/model_chooser_page.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';
import 'package:collection/collection.dart';

class ModelButton extends StatefulWidget {
  const ModelButton({super.key});

  @override
  State<ModelButton> createState() => _ModelButtonState();
}

class _ModelButtonState extends State<ModelButton> {
  String currentModel = "stable_diffusion";

  @override
  void initState() {
    super.initState();
    sharedPrefsBloc.getModel().then((model) {
      setState(() {
        currentModel = model;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 1,
      child: GestureDetector(
        onTap: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ModelChooserPage(),
            ),
          );

          sharedPrefsBloc.getModel().then((model) {
            setState(() {
              currentModel = model;
            });
          });
        },
        child: SectionFrame(
          padding: 8,
          child: SizedBox(
            height: 72,
            child: FutureBuilder<List<StableHordeModel>>(
              future: modelsBloc.getModels(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  print(snapshot.stackTrace);
                  Sentry.captureException(
                    snapshot.error,
                    stackTrace: snapshot.stackTrace,
                  );
                }

                final models = snapshot.data ?? [];
                final model = models.firstWhereOrNull(
                  (model) => model.name == currentModel,
                );

                final Widget image;
                if (model == null) {
                  image = const SizedBox();
                } else {
                  image = CachedNetworkImage(
                    imageUrl: model.previewImageUrl,
                  );
                }

                return Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 4,
                          top: 4,
                          bottom: 4,
                          right: 8,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(currentModel),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                model?.description ?? "",
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: image,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

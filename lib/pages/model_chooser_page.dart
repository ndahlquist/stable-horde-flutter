
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/stable_horde_bloc.dart';
import 'package:stable_horde_flutter/model/stable_diffusion_model.dart';

class ModelChooserPage extends StatelessWidget {
  const ModelChooserPage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF230D49),
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: FutureBuilder<List<StableDiffusionModel>>(
        future: stableHordeBloc.getModels(),
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
          return ListView.builder(
            itemCount: models.length,
            itemBuilder: (context, index) {
              final model = models[index];
              return Column(
                children: [
                  Text(model.name),
                  Text(model.description),
                ],
              );
            },
          );
        },
      ),
    );
  }

}
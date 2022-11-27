import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vector_math/vector_math_64.dart';

import 'dart:ui' as ui;

class SdResult {
  final String? inputImageUrl;
  final String outputImageUrl;
  final Matrix4 transform;

  final String prompt;
  final double mutationRate;

  ui.Image? loadedImage;

  SdResult(
    this.inputImageUrl,
    this.outputImageUrl,
    this.transform,
    this.prompt,
    this.mutationRate,
  );

  static SdResult fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    try {
      final Matrix4 transform;
      if (data!.containsKey('transform')) {
        final transformData = data['transform'] as List<dynamic>;
        transform = Matrix4.fromList(transformData.cast<double>());
      } else {
        transform = Matrix4.identity();
      }

      return SdResult(
        data['input_image_url'] as String?,
        data['output_image_url'] as String,
        transform,
        data['prompt'] as String,
        data['mutation_rate'] as double,
      );
    } catch (err) {
      print(err);
      print("Failed to deserialize $SdResult: ${snapshot.id} $data");
      rethrow;
    }
  }
}

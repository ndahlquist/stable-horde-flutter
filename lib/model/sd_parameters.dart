import 'package:cloud_firestore/cloud_firestore.dart';

class SdParameters {
  String prompt;
  double mutationRate;

  SdParameters(this.prompt, this.mutationRate);

  static SdParameters? fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      return null;
    }

    try {
      final prompt = data['prompt'] as String?;
      final mutationRate = data['mutation_rate'] as double?;
      if (prompt == null || mutationRate == null) {
        return null;
      }
      return SdParameters(
        prompt,
        mutationRate,
      );
    } catch (err) {
      print(err);
      print("Failed to deserialize $SdParameters: ${snapshot.id} $data");
      rethrow;
    }
  }
}

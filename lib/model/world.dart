import 'package:cloud_firestore/cloud_firestore.dart';

class World {
  final String id;
  final String? imageUrl;
  final String userId;
  final bool published;
  final DateTime lastUpdated;
  final String? prompt;

  World(
    this.id, {
    required this.imageUrl,
    required this.published,
    required this.userId,
    required this.lastUpdated,
    required this.prompt,
  });

  static World fromDocument(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    try {
      return World(
        snapshot.id,
        imageUrl: data!['image_url'] as String?,
        published: data['publish'] as bool? ?? false,
        userId: data['user_id'] as String,
        lastUpdated: (data['last_updated'] as Timestamp).toDate(),
        prompt: data['prompt'] as String?,
      );
    } catch (err) {
      print(err);
      print("Failed to deserialize $World: ${snapshot.id} $data");
      rethrow;
    }
  }
}

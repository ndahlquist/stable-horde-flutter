import 'dart:async';
import 'dart:ui' as ui;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ImageLayer {
  final Matrix4 transform;

  final String? imageUrl;

  ui.Image? image;

  final String? prompt;
  final double? mutationRate;
  final String? userId;

  ImageLayer(
    this.transform, {
    this.imageUrl,
    this.image,
    this.prompt,
    this.mutationRate,
    this.userId,
  });

  static ImageLayer fromDocument(
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

      return ImageLayer(
        transform,
        imageUrl: data['image_url'] as String?,
      );
    } catch (err) {
      print(err);
      print("Failed to deserialize $ImageLayer: ${snapshot.id} $data");
      rethrow;
    }
  }

  Future<ui.Image> loadImageFromUrl() async {
    if (image != null) {
      return image!;
    }

    final completer = Completer<ui.Image>();

    final imageStreamListener = ImageStreamListener(
      (info, _) {
        image = info.image;
        if (!completer.isCompleted) {
          completer.complete(image);
        }
      },
    );

    final provider =
        CachedNetworkImageProvider(imageUrl!).resolve(ImageConfiguration());
    provider.addListener(imageStreamListener);

    completer.future.whenComplete(() {
      provider.removeListener(imageStreamListener);
    });

    return completer.future;
  }

  Map<String, dynamic> toMapForFirestore() {
    return {
      'transform': transform.storage,
      'image_url': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
      'prompt': prompt,
      'mutation_rate': mutationRate,
    };
  }
}

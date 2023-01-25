import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stable_horde_flutter/model/stable_horde_task.dart';

class _TranscodeParam {
  final File inputFile;
  final File outputFile;

  _TranscodeParam(this.inputFile, this.outputFile);
}

class _ImageTranscodeBloc {
  void _saveImageJpeg(_TranscodeParam param) {
    final image = decodeWebP(param.inputFile.readAsBytesSync())!;

    param.outputFile.writeAsBytesSync(encodeJpg(image));
  }

  Future<File> transcodeImageToJpg(StableHordeTask task) async {
    final directory = await getApplicationSupportDirectory();
    final inputFile = File('${directory.path}/${task.imageFilename!}');

    final String dir = (await getTemporaryDirectory()).path;

    final outputFile = File(
      "$dir/${DateTime.now().millisecondsSinceEpoch}.jpg",
    );

    await compute(
      _saveImageJpeg,
      _TranscodeParam(inputFile, outputFile),
    );

    return outputFile;
  }

  String? _transcodeToSquareB64Jpg(Uint8List bytes) {
    Image? image = decodeImage(bytes);
    if (image == null) return null;

    // For non-square images, crop down to center square
    final int x = (image.width - image.height) ~/ 2;
    final int y = (image.height - image.width) ~/ 2;
    final int w = image.height;
    final int h = image.width;

    if (x != 0 || y != 0 || w != image.width || h != image.height) {
      image = copyCrop(image, x, y, w, h);
    }

    final transcodedBytes = encodeJpg(image);
    return base64.encode(transcodedBytes);
  }

  Future<String?> transcodeImageToSquareJpgBytes(
    Uint8List inputB64Bytes,
  ) async {
    return await compute(
      _transcodeToSquareB64Jpg,
      inputB64Bytes,
    );
  }
}

final imageTranscodeBloc = _ImageTranscodeBloc();

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
  void _saveImage(_TranscodeParam param) {
    final image = decodeWebP(param.inputFile.readAsBytesSync())!;

    param.outputFile.writeAsBytesSync(encodeJpg(image));
  }

  Future<File> transcodeImageToJpg(StableHordeTask task) async {
    final directory = await getApplicationDocumentsDirectory();
    final inputFile = File(directory.path + '/' + task.imageFilename!);

    final String dir = (await getTemporaryDirectory()).path;

    final outputFile = File(
      "$dir/${DateTime.now().millisecondsSinceEpoch}.jpg",
    );

    await compute(
      _saveImage,
      _TranscodeParam(inputFile, outputFile),
    );

    return outputFile;
  }
}

final imageTranscodeBloc = _ImageTranscodeBloc();

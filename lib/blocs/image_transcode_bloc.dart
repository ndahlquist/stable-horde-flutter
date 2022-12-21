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

  Future<File> transcodeAndSaveImage(StableHordeTask task) async {
    final inputFile = File(task.imagePath!);

    final String downloadDir;
    if (Platform.isAndroid) {
      downloadDir = "/storage/emulated/0/Download/";
    } else if (Platform.isIOS) {
      downloadDir = (await getApplicationDocumentsDirectory()).path;
    } else {
      throw Exception("Unsupported platform");
    }

    final outputFile = File("$downloadDir${task.id}.jpg");

    await compute(
      _saveImage,
      _TranscodeParam(inputFile, outputFile),
    );

    return outputFile;
  }
}

final imageTranscodeBloc = _ImageTranscodeBloc();

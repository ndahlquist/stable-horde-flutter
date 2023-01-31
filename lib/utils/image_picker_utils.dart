import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/image_transcode_bloc.dart';

// Util function that picks image give ImageSource
// maxWidth and maxHeight is optional but 512x512 by default.
Future<String?> pickImage(
  ImageSource source, {
  double maxWidth = 512,
  double maxHeight = 512,
}) async {
  final ImagePicker _imagePicker = ImagePicker();

  try {
    XFile? _file = await _imagePicker.pickImage(
      source: source,
      maxHeight: maxHeight,
      maxWidth: maxWidth,
    );

    if (_file == null) return null;
    final Uint8List bytes = await _file.readAsBytes();
    return await imageTranscodeBloc.transcodeImageToSquareJpgBytes(bytes);
  } on PlatformException catch (error, stackTrace) {
    print(error.toString());
    Sentry.captureException(error, stackTrace: stackTrace);
    return error.code;
  } on Exception catch (error, stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);
    print(error.toString());
    return null;
  }
}

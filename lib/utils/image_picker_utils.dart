import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Util function that picks image give ImageSource
// maxWidth and maxHeight is optional but 512x512 by default.
pickImage(
  ImageSource source, {
  double maxWidth = 512,
  double maxHeight = 512,
}) async {
  final ImagePicker _imagePicker = ImagePicker();

  try {
    XFile? _file = await _imagePicker.pickImage(
        source: source, maxHeight: maxHeight, maxWidth: maxWidth);

    if (_file != null) {
      return await _file.readAsBytes();
    }
  } catch (error, stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);
    print(error.toString());
  }
}

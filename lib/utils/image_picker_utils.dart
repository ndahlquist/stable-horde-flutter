import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

// Util function that picks image give ImageSource
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  try {
    XFile? _file = await _imagePicker.pickImage(source: source);
    if (_file != null) {
      return await _file.readAsBytes();
    }
  } catch (error, stackTrace) {
    Sentry.captureException(error, stackTrace: stackTrace);
    print(error.toString());
  }
}

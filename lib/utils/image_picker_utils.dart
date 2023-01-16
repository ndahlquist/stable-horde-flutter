import 'package:image_picker/image_picker.dart';

// Util function that picks image give ImageSource
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);

  if (_file != null) {
    return await _file.readAsBytes();
  } else {
    // TODO: Log it on sentry.
  }

  print('No image selected!');
}

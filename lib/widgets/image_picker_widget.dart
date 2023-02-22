import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:stable_horde_flutter/blocs/conversions_bloc.dart';
import 'package:stable_horde_flutter/blocs/shared_prefs_bloc.dart';
import 'package:stable_horde_flutter/dialogs/login_dialog.dart';
import 'package:stable_horde_flutter/utils/image_picker_utils.dart';
import 'package:stable_horde_flutter/widgets/control_type_box.dart';
import 'package:stable_horde_flutter/widgets/denoising_strength_box.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const Text(
        "Img2Img",
        style: TextStyle(fontSize: 18),
      ),
      collapsed: const SizedBox.shrink(),
      expanded: _img2ImgOption(),
      theme: const ExpandableThemeData(
        iconColor: Colors.white,
      ),
    );
  }

  Widget _img2ImgOption() {
    return FutureBuilder<String?>(
      future: sharedPrefsBloc.getImg2ImgInput(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          print(snapshot.stackTrace);
          Sentry.captureException(
            snapshot.error,
            stackTrace: snapshot.stackTrace,
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          // Loading
          return const Padding(
            padding: EdgeInsets.all(12),
            child: CircularProgressIndicator(),
          );
        }

        String? img2ImgInput = snapshot.data;

        Widget image;
        if (img2ImgInput != null) {
          Uint8List inputFile = base64.decode(img2ImgInput);
          image = Stack(
            children: [
              Positioned(
                child: GestureDetector(
                  onTap: () => _onClickImg2Img(context),
                  child: SizedBox(
                    height: 216,
                    width: 216,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: MemoryImage(inputFile),
                          fit: BoxFit.fill,
                          alignment: FractionalOffset.topCenter,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                right: -16,
                child: RawMaterialButton(
                  onPressed: _onDeleteSelectedImage,
                  elevation: 2.0,
                  fillColor: Colors.black.withOpacity(.5),
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.delete,
                    size: 20.0,
                  ),
                ),
              ),
            ],
          );
        } else {
          // No img selected yet
          image = GestureDetector(
            onTap: () => _onClickImg2Img(context),
            child: DottedBorder(
              borderType: BorderType.RRect,
              radius: const Radius.circular(12),
              dashPattern: const [10, 4],
              strokeCap: StrokeCap.round,
              color: Colors.white,
              child: Container(
                width: double.infinity,
                height: 216,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.cloud_upload_rounded,
                      size: 40,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Text(
                      'Select your image',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return FractionallySizedBox(
          widthFactor: 1,
          child: SectionFrame(
            padding: 8,
            child: Column(
              children: [
                SizedBox(
                  height: 216,
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 4,
                            top: 4,
                            bottom: 4,
                            right: 8,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Input '),
                              SizedBox(height: 8),
                            ],
                          ),
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: image,
                        ),
                      ),
                    ],
                  ),
                ),
                const ControlTypeBox(),
                const DenoisingStrengthBox(),
              ],
            ),
          ),
        );
      },
    );
  }

  _onClickImg2Img(BuildContext context) async {
    var apiKey = await sharedPrefsBloc.getApiKey();
    if (!mounted) return;

    if (apiKey == null) {
      // user not logged in
      conversionsBloc.beginLogin();

      await showDialog(
        context: context,
        builder: (_) {
          return const LoginDialog(
            title: "You are currently anonymous. Login to use Img2Img.",
          );
        },
      );

      // Refresh the UI.
      setState(() {});
    } else {
      // continue selecting an image
      _selectImage(context);
    }
  }

  _selectImage(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select source'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Take a photo'),
              onPressed: () async {
                onImagePick(ImageSource.camera);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                onImagePick(ImageSource.gallery);
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Cancel'),
              onPressed: () async {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _onDeleteSelectedImage() async {
    await sharedPrefsBloc.setImg2ImgInput(null);
    // Refresh the UI.
    setState(() {});
  }

  void onImagePick(ImageSource imageSource) async {
    Navigator.of(context).pop();

    final img2ImgInputEncodedString = await pickImage(imageSource);

    // Check if pickImage thrown PlatformException
    final String? error;
    if (img2ImgInputEncodedString == null) {
      error = "Something went wrong, please try again.";
    } else if (img2ImgInputEncodedString == "photo_access_denied") {
      error = "Please allow photo access to use Img2Img.";
    } else if (img2ImgInputEncodedString == "camera_access_denied") {
      error = "Please allow camera access to use Img2Img.";
    } else {
      error = null;
    }

    if (error == null) {
      await sharedPrefsBloc.setImg2ImgInput(img2ImgInputEncodedString);
      if (!mounted) return;
      // Refresh the UI.
      setState(() {});
    } else {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text(error!),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }
}

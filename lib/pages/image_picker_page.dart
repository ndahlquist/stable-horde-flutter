import 'package:dotted_border/dotted_border.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stable_horde_flutter/utils/image_picker_utils.dart';
import 'package:stable_horde_flutter/widgets/section_frame.dart';

class ImagePickerPage extends StatefulWidget {
  const ImagePickerPage({super.key});

  @override
  State<ImagePickerPage> createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  Uint8List? _file;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpandablePanel(
          header: const Text(
            "Img2Img",
            style: TextStyle(fontSize: 18),
          ),
          collapsed: const SizedBox.shrink(),
          expanded: _img2ImgOption(),
          theme: const ExpandableThemeData(
            iconColor: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _img2ImgOption() {
    Widget image;
    if (_file == null) {
      image = GestureDetector(
        onTap: () => _selectImage(context),
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
                borderRadius: BorderRadius.circular(8)),
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
    } else {
      image = Stack(
        children: [
          Positioned(
            child: GestureDetector(
              onTap: () => _selectImage(context),
              child: SizedBox(
                height: 216,
                width: 216,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                    image: MemoryImage(_file!),
                    fit: BoxFit.fill,
                    alignment: FractionalOffset.topCenter,
                  )),
                ),
              ),
            ),
          ),
          if (_file != null)
            Positioned(
              right: -16,
              child: RawMaterialButton(
                onPressed: _removeSelectedImage,
                elevation: 2.0,
                fillColor: Colors.black.withOpacity(.5),
                shape: const CircleBorder(),
                child: const Icon(
                  Icons.delete,
                  size: 20.0,
                ),
              ),
            )
        ],
      );
    }

    return FractionallySizedBox(
      widthFactor: 1,
      child: SectionFrame(
        padding: 8,
        child: SizedBox(
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
      ),
    );
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
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.camera);

                setState(() {
                  _file = file;
                });
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Choose from gallery'),
              onPressed: () async {
                Navigator.of(context).pop();
                Uint8List file = await pickImage(ImageSource.gallery);

                setState(() {
                  _file = file;
                });
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

  void _removeSelectedImage() {
    setState(() {
      _file = null;
    });
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Widget for displaying and picking a profile picture.
/// Author(s): Eduard Ragea
class UserImagePicker extends StatefulWidget {
  const UserImagePicker(this.imagePickFn, {Key? key}) : super(key: key);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  /// Take or choose a picture and call the function
  /// passed through the constructor.
  void _pickImage(bool isCamera) async {
    final pickedImageFile = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (pickedImageFile != null) {
      setState(() {
        _pickedImage = File(pickedImageFile.path);
      });
      widget.imagePickFn(File(pickedImageFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: _pickedImage != null
              ? FileImage(_pickedImage!)
              : Image.asset('assets/images/default_profile_picture.jpg').image,
        ),
        TextButton.icon(
          onPressed: () => _pickImage(true),
          icon: const Icon(Icons.camera),
          label: const Text('Take a picture'),
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        TextButton.icon(
          onPressed: () => _pickImage(false),
          icon: const Icon(Icons.image),
          label: const Text('Choose from gallery'),
          style: TextButton.styleFrom(
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }
}

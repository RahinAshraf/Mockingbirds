import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  UserImagePicker(this.imagePickFn);

  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  void _pickImage(bool isCamera) async {
    final pickedImageFile = await ImagePicker().getImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
    widget.imagePickFn(File(pickedImageFile!.path));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.green,
          backgroundImage:
              _pickedImage != null ? FileImage(_pickedImage!) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: () => _pickImage(true),
          icon: Icon(Icons.camera),
          label: Text('Take a picture'),
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: () => _pickImage(false),
          icon: Icon(Icons.image),
          label: Text('Choose from gallery'),
        ),
      ],
    );
  }
}

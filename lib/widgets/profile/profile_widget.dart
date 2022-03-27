import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileWidget extends StatefulWidget {
  String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  ProfileWidget(this.imagePath, this.onClicked, this.isEdit, {Key? key})
      : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  Widget buildImage() {
    final image = NetworkImage(widget.imagePath);
    return ClipOval(
      child: Material(
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: widget.onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: Icon(
            widget.isEdit ? Icons.add_a_photo : Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );

  void showPicker() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: [
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      setPicture(false);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    setPicture(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  Future setPicture(bool isCamera) async {
    final _userID = FirebaseAuth.instance.currentUser!.uid;
    final _pickedImageFile = await ImagePicker().pickImage(
      source: isCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 150,
    );
    if (_pickedImageFile != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(_userID + '.jpg');
      try {
        await ref.putFile(File(_pickedImageFile.path));
        widget.imagePath = await ref.getDownloadURL();
        FirebaseFirestore.instance
            .collection('users')
            .doc(_userID)
            .set({'image_url': widget.imagePath}, SetOptions(merge: true));
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
          ),
        );
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: widget.isEdit
          ? Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: buildImage(),
                ),
                Positioned(
                  bottom: 0,
                  right: 6,
                  child: GestureDetector(
                    onTap: showPicker,
                    child: buildEditIcon(color),
                  ),
                ),
              ],
            )
          : Padding(padding: const EdgeInsets.all(15.0), child: buildImage()),
    );
  }
}

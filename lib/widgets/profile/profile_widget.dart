import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:veloplan/styles/colors.dart';

/// Widget for displaying the profile picture.
/// Author(s): Eduard Ragea k20067643
class ProfileWidget extends StatefulWidget {
  String imagePath;
  final VoidCallback onClicked;

  ProfileWidget(this.imagePath, this.onClicked, {Key? key}) : super(key: key);

  @override
  State<ProfileWidget> createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: _buildImage(),
          ),
          Positioned(
            bottom: 0,
            right: 6,
            child: GestureDetector(
              onTap: _showPicker,
              child: _buildEditIcon(CustomColors.green),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
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

  Widget _buildEditIcon(Color color) => _buildCircle(
        color: Colors.white,
        all: 3,
        child: _buildCircle(
          color: color,
          all: 8,
          child: Icon(
            Icons.add_a_photo,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget _buildCircle({
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

  /// Show a bottom picker to choose between taking a picture
  /// with camera or choosing one form gallery.
  void _showPicker() {
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
                      _setPicture(false);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _setPicture(true);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  /// Take or choose a picture for profile and update it on server.
  /// Show error in case the operation fails.
  Future _setPicture(bool isCamera) async {
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
}

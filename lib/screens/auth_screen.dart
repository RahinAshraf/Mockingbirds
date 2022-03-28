import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:veloplan/widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  // Function logs in or signs up with the
  // data passed.
  // In the case of sign up a document for 
  // the new user and a photo are created 
  // and uploaded to the server.
  // When no picture is passed the 
  // document will create a link to the 
  // default profile picture.
  // Throws FirebaseAuthException if there
  // is a Problem with the serverside part 
  // like user tries to sign up with an 
  // already used email.
  // Throws error in case of user failing to 
  // interact with the platform
  // In the case of any other error the app
  // creates a new state so the user can try 
  // authentication again.
  void _submitAuthForm(
    String email,
    String password,
    String username,
    String firstName,
    String lastName,
    File? image,
    DateTime dateTime,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential authResult;

    try {
      // Set isLoading to true in order to not let
      // the user to call this function again.
      setState(() {
        _isLoading = true;
      });
      // Determine whether the user wants to login
      // or create a new account and perform the action.
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);

        // URL set for the default profile picture 
        // which is already on the server.
        var url = "assets/images/default_profile_picture.jpg";

        // Upload the current image to the server.
        if (image != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(authResult.user!.uid + '.jpg');

          await ref.putFile(image);

          url = await ref.getDownloadURL();
        }

        // Create document for the newly created user
        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user!.uid)
            .set({
          'username': username,
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'image_url': url,
          'birthDate': dateTime,
        });
      }
    } on PlatformException catch (err) {
      var message = 'An error occurred, please check your credentials!';

      if (err.message != null) {
        message = err.message!;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // In case of any other kind of failure the
      // function should be able to called again. 
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            AuthForm(
              _submitAuthForm,
              _isLoading,
            ),
            Align(
              alignment: Alignment.topRight,
              child: Image.asset(
                'assets/images/right_bubbles_shapes.png',
                height: 170.0,
                width: 170.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

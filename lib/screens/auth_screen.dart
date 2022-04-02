import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:veloplan/helpers/database_helpers/database_manager.dart';

import 'package:veloplan/widgets/auth/auth_form.dart';

/// Screen for the user authentication - Signing Up and Logging In
/// Author(s): Eduard Ragea k20067643
class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;

  /// Authenticate the user with Firebase.
  /// Log in with [email] and [password] if [isLogin] is true. In the case
  /// of signing up, vreate a user on Firebase Authentication. 
  /// Set url to default profile pictore if 
  /// none is choosen, otherwise save it to Firebase Storage.
  /// Create a document for the user in the Cloud Firestore with their details.
  /// Set state in order to deactivate and activate the Log In/Sign Up button, 
  /// so the user can't perform this action twice in the same time.
  /// Handle errors by showing snackbars with the message.
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
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        var url =
            "https://firebasestorage.googleapis.com/v0/b/veloplan-b41d0.appspot.com/o/user_image%2Fdefault_profile_picture.jpg?alt=media&token=edc6abb8-3655-448c-84a0-7d34b02f0c73";

        if (image != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_image')
              .child(authResult.user!.uid + '.jpg');

          await ref.putFile(image);

          url = await ref.getDownloadURL();
        }
        final DatabaseManager _databaseManager = DatabaseManager();
        await _databaseManager.setByKey('users', authResult.user!.uid, {
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

      Scaffold.of(ctx).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Theme.of(ctx).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(err.message!),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      setState(() {
        _isLoading = false;
      });
    } catch (err) {
      // print(err);
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
              child: Container(
                  height: 170.0,
                  width: 170.0,
                  alignment: Alignment.topRight,
                  child: Image.asset('assets/images/right_bubbles_shapes.png')),
            ),
          ],
        ),
      ),
    );
  }
}

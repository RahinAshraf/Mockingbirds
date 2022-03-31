/// Helpers for interacting with settings
/// Author(s): Eduard Ragea k20067643

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<bool> checkCurrentPassword(String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    final authCredential = EmailAuthProvider.credential(
        email: currentUser!.email!, password: password);

    try {
      final authResult =
          await currentUser.reauthenticateWithCredential(authCredential);

      return authResult.user != null;
    } catch (e) {
      return false;
    }
  }

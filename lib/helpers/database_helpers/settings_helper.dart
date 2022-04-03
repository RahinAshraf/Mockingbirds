import 'package:firebase_auth/firebase_auth.dart';

/// Helpers for interacting with settings
/// Author(s): Eduard Ragea k20067643

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

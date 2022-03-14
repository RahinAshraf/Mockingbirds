import 'package:firebase_auth/firebase_auth.dart';

String getUid() {
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  return uid;
}
//delete this
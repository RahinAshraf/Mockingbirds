import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseManager {
  DatabaseManager();

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getByEquality(
      String collection, String field, String equalTo) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: equalTo)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getByKey(
      String collection, String key) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .get();
  }

  Future<void> setByKey(
      String collection, String key, Map<String, dynamic> value,
      [SetOptions? options]) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .set(value, options);
  }

  Future<void> updateByKey(
      String collection, String key, Map<String, dynamic> value) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .update(value);
  }

  Future<void> addToCollection(
      String collection, Map<String, dynamic> value) async {
    await FirebaseFirestore.instance.collection(collection).add(value);
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}
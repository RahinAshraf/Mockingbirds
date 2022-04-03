import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Helper functions for database usage
///Author: Lilliana
///Contributor: Tayyibah
class DatabaseManager {
  late FirebaseFirestore _database;
  late final _userId;

  DatabaseManager() {
    _database = FirebaseFirestore.instance;
    _userId = FirebaseAuth.instance.currentUser!.uid;
  }

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }
@deprecated
  CollectionReference<Object?> getUserSubCollectionReference(
      String collectionName) {
    return _database
        .collection('users')
        .doc(_userId)
        .collection(collectionName);
  }


  Future<QuerySnapshot<Object?>> getUserSubcollection(
      String subcollection) async {
    return await _database
        .collection('users')
        .doc(_userId)
        .collection(subcollection)
        .get();
  }

  Future deleteCollection(CollectionReference<Object?> collection) async {
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> deleteDocument(
      CollectionReference<Object?> collection, String documentId) {
    return collection.doc(documentId).delete();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getByEquality(
      String collection, String field, String equalTo) async {
    return await _database
        .collection(collection)
        .where(field, isEqualTo: equalTo)
        .get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getByKey(
      String collection, String key) async {
    return await _database.collection(collection).doc(key).get();
  }

  Future<void> setByKey(
      String collection, String key, Map<String, dynamic> value,
      [SetOptions? options]) async {
    await _database
        .collection(collection)
        .doc(key)
        .set(value, options);
  }

  Future<void> updateByKey(
      String collection, String key, Map<String, dynamic> value) async {
    await _database.collection(collection).doc(key).update(value);
  }

  Future<DocumentReference<Map<String, dynamic>>> addToCollection(
      String collection, Map<String, dynamic> value) async {
   return await _database.collection(collection).add(value);
  }



  Future<DocumentReference<Object?>> addToSubCollection(CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) async {
   return await subcollection.add(value);
  }


  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}

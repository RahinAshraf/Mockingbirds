import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///Helper functions for database usage
///Author: Lilliana
///Contributor: Tayyibah
class DatabaseManager {
  DatabaseManager() {}

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @deprecated
  CollectionReference<Object?> getUserSubCollectionReference(
      String collectionName) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser()!.uid)
        .collection(collectionName);
  }

  Future<QuerySnapshot<Object?>> getUserSubcollection(
      String subcollection) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
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

  Future<DocumentReference<Map<String, dynamic>>> addToCollection(
      String collection, Map<String, dynamic> value) async {
    return await FirebaseFirestore.instance.collection(collection).add(value);
  }

  Future<void> addToSubCollection(CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) async {
    await subcollection.add(value);
  }

  Future<void> addSubCollectiontoSubCollectionByDocumentId(
      documentId,
      String newSubollection,
      CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) {
    return subcollection.doc(documentId).collection(newSubollection).add(value);
  }

  Future<void> setSubCollectionByDocumentId(String documentId,
      CollectionReference<Object?> subcollection, Map<String, dynamic> value) {
    return subcollection.doc(documentId).set(value);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDocumentsFromSubCollection(
      CollectionReference<Object?> collection,
      documentId,
      String subcollection) async {
    return await collection.doc(documentId).collection(subcollection).get();
  }

  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}

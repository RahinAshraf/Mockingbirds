import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Helper functions for database usage.
/// Author: Lilianna
/// Contributor: Tayyibah
class DatabaseManager {
  DatabaseManager() {}

  /// Return the current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  ///Return a reference to the user's given subcollection
  CollectionReference<Object?> getUserSubCollectionReference(
      String collectionName) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser()!.uid)
        .collection(collectionName);
  }

  ///Return the user's given subcollection
  Future<QuerySnapshot<Object?>> getUserSubcollection(
      String subcollection) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(subcollection)
        .get();
  }

  /// Delete the given collection
  Future deleteCollection(CollectionReference<Object?> collection) async {
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  /// Delete the given document
  Future<void> deleteDocument(
      CollectionReference<Object?> collection, String documentId) {
    return collection.doc(documentId).delete();
  }

  ///Get a document by one of its fields
  Future<QuerySnapshot<Map<String, dynamic>>> getByEquality(
      String collection, String field, String equalTo) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: equalTo)
        .get();
  }

  ///Get a document by its key
  Future<DocumentSnapshot<Map<String, dynamic>>> getByKey(
      String collection, String key) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .get();
  }

  ///Set a document's value by its collection name and key
  Future<void> setByKey(
      String collection, String key, Map<String, dynamic> value,
      [SetOptions? options]) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .set(value, options);
  }

///Update the document's value by it's key
  Future<void> updateByKey(
      String collection, String key, Map<String, dynamic> value) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .update(value);
  }

  /// Add a new document into the given collection given by collection name
  Future<DocumentReference<Map<String, dynamic>>> addToCollection(
      String collection, Map<String, dynamic> value) async {
    return await FirebaseFirestore.instance.collection(collection).add(value);
  }
/// Add a new document into the given collection given by reference
  Future<DocumentReference<Object?>> addToSubCollection(
      CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) async {
    return await subcollection.add(value);
  }

  /// Add a new document into a subcollection
  Future<void> addSubCollectiontoCollectionByDocumentId(
      documentId,
      String newSubcollection,
      CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) {
    return subcollection.doc(documentId).collection(newSubcollection).add(value);
  }

  ///Set the value of a subcollection's document
  Future<void> setSubCollectionByDocumentId(String documentId,
      CollectionReference<Object?> subcollection, Map<String, dynamic> value) {
    return subcollection.doc(documentId).set(value);
  }


  ///Return a documents from a given document's subcollection
  Future<QuerySnapshot<Map<String, dynamic>>> getDocumentsFromSubCollection(
      CollectionReference<Object?> collection,
      documentId,
      String subcollection) async {
    return await collection.doc(documentId).collection(subcollection).get();
  }


  /// Sign out
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}

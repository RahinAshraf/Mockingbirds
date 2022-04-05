import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Helper functions that allow queries to and from the firebase database.
/// Author(s): Lilliana, Tayyibah
class DatabaseManager {
  DatabaseManager() {}

  /// Return the current user
  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  /// Returns a subcollection reference for users given a name for the new collection.
  CollectionReference<Object?> getUserSubCollectionReference(
      String collectionName) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(getCurrentUser()!.uid)
        .collection(collectionName);
  }


  /// Returns query snapshots from an existing users subcollection.

  Future<QuerySnapshot<Object?>> getUserSubcollection(
      String subcollection) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(subcollection)
        .get();
  }

  /// Deletes all the documents in a collection given its reference.
  Future deleteCollection(CollectionReference<Object?> collection) async {
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  /// Deletes a single document from a collection given its document ID and collection reference.
  Future<void> deleteDocument(
      CollectionReference<Object?> collection, String documentId) {
    return collection.doc(documentId).delete();
  }

  /// Returns a value from a collection which matches given string.
  Future<QuerySnapshot<Map<String, dynamic>>> getByEquality(
      String collection, String field, String equalTo) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .where(field, isEqualTo: equalTo)
        .get();
  }


  /// Returns a document  from a collection given the document ID.

  Future<DocumentSnapshot<Map<String, dynamic>>> getByKey(
      String collection, String key) async {
    return await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .get();
  }

  /// Sets the value of a document in a subcollection given its document ID.
  Future<void> setByKey(
      String collection, String key, Map<String, dynamic> value,
      [SetOptions? options]) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .set(value, options);
  }


  /// Updates the value of a document in a subcollection given its document ID.
  Future<void> updateByKey(
      String collection, String key, Map<String, dynamic> value) async {
    await FirebaseFirestore.instance
        .collection(collection)
        .doc(key)
        .update(value);
  }


  /// Adds a value to a collection and returns its document reference.
  Future<DocumentReference<Map<String, dynamic>>> addToCollection(
      String collection, Map<String, dynamic> value) async {
    return await FirebaseFirestore.instance.collection(collection).add(value);
  }


  /// Adds value to a subcollection given its reference and returns a reference to the new document.
  Future<DocumentReference<Object?>> addToSubCollection(
      CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) async {
    return await subcollection.add(value);
  }


  /// Adds a value to a subcollection within a subcollection given a document ID.
  Future<void> addSubCollectiontoSubCollectionByDocumentId(
      documentId,
      String newSubcollection,
      CollectionReference<Object?> subcollection,
      Map<String, dynamic> value) {
    return subcollection.doc(documentId).collection(newSubcollection).add(value);
  }


  /// Sets value of document in a subcollection given its reference and document ID.
  Future<void> setSubCollectionByDocumentId(String documentId,
      CollectionReference<Object?> subcollection, Map<String, dynamic> value) {
    return subcollection.doc(documentId).set(value);
  }

  /// Returns snapshots for each of the documents in a subcollection given its reference.
  Future<QuerySnapshot<Map<String, dynamic>>> getDocumentsFromSubCollection(
      CollectionReference<Object?> collection,
      documentId,
      String subcollection) async {
    return await collection.doc(documentId).collection(subcollection).get();
  }

  /// Signs a user out of the app.
  Future<void> signOut() async {
    FirebaseAuth.instance.signOut();
  }
}

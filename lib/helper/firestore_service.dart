import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  const FirestoreService({required this.firestore});

  final FirebaseFirestore firestore;

  /// COLLECTION OPERATIONS

  Future<DocumentReference<Map<String, dynamic>>> addToMessageCollection({
    required String comName,
    required String displayName,
    required String email,
    required String texts,
  }) async {
    return firestore
        .collection("Communities")
        .doc(comName)
        .collection("User Posts")
        .add({
      'Username': displayName,
      'UserEmail': email,
      'Message': texts,
      'Likes': [],
    });
  }

  Future<DocumentReference<Map<String, dynamic>>> addToCollection(
      {required Map<String, dynamic> data,
      required String collectionPath}) async {
    return firestore.collection(collectionPath).add(data);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getFromCollection(
      {required String collectionPath}) {
    return firestore.collection(collectionPath).get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getSnapshotStreamFromCollection(
      {required String collectionPath}) {
    return firestore.collection(collectionPath).snapshots();
  }

  /// DOCUMENT OPERATIONS

  Future<void> deleteDocumentFromCollection(
      {required String collectionPath, required String documentPath}) async {
    return firestore.collection(collectionPath).doc(documentPath).delete();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getFromDocument(
      {required String collectionPath, required String documentPath}) {
    return firestore.collection(collectionPath).doc(documentPath).get();
  }

  Future<void> setDataOnDocument(
      {required Map<String, dynamic> data,
      required String collectionPath,
      required String documentPath}) {
    return firestore.collection(collectionPath).doc(documentPath).set(data);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> getSnapshotStreamFromDocument(
      {required String collectionPath, required String documentPath}) {
    return firestore.collection(collectionPath).doc(documentPath).snapshots();
  }

  Future<void> updateDataOnDocument(
      {required Map<String, dynamic> data,
      required String collectionPath,
      required String documentPath}) {
    return firestore.collection(collectionPath).doc(documentPath).update(data);
  }
}

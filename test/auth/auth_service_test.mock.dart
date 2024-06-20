import 'package:mockito/annotations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  FirebaseFirestore,
  DocumentReference,
  CollectionReference<Map<String, dynamic>>, // Update to include correct generic type
])
void main() {}

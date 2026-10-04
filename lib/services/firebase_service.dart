import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
  FirebaseDatabase.instance.ref();

  Future<User?> registerUser({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    final credential =
    await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    if (user == null) {
      throw Exception('Could not create user.');
    }

    await _database
        .child('users')
        .child(user.uid)
        .set({
      'userId': user.uid,
      ...userData,
    });

    return user;
  }

  Future<User?> loginUser({
    required String email,
    required String password,
  }) async {
    final credential =
    await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user;
  }

  Future<Map<String, dynamic>?> getUserData() async {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    final snapshot = await _database
        .child('users')
        .child(user.uid)
        .get();

    if (!snapshot.exists) {
      return null;
    }

    return Map<String, dynamic>.from(
      snapshot.value as Map,
    );
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
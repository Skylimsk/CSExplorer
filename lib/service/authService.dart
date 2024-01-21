// ignore_for_file: unused_local_variable, use_build_context_synchronously, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUp(
    String name,
    String email,
    String password,
    String role,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      setUserData(name, email, role);

      User? user = userCredential.user;

      // Send email verification
      user = _auth.currentUser;
      await user?.sendEmailVerification();
      await _auth.signOut();
      return '';
    } catch (e) {
      return "Invalid email or email already in use.";
    }
  }

  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      await user?.delete();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .delete();
    } catch (e) {
      print("Error deleting account: $e");
    }
  }

  Future<String> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      User? user = userCredential.user;
      return '';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found';
      } else if (e.code == 'wrong-password') {
        return 'Invalid password';
      }
      return 'Invalid email or password';
    }
  }

  Future<void> logOut() async {
    await _auth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return FirebaseAuth.instance.currentUser;
  }

  setUserData(String username, String email, String role) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref
        .doc(user!.uid)
        .set({'username': username, 'email': email, 'role': role});
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data();
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('Unseccessful password update');
    }
  }

  static String getCurrentUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  static Future<String> getUserNameById(String id) async {
    var userDoc =
        await FirebaseFirestore.instance.collection('users').doc(id).get();
    return userDoc.data()!['username'];
  }
}

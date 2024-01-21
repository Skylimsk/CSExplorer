// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csexplorer/data/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart'
    as firebaseAuth; // Use an alias

class UserRepository {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<List<User>> getUsersByRole(String targetRole) async {
    List<User> users = [];

    QuerySnapshot querySnapshot =
        await _usersCollection.where('role', isEqualTo: targetRole).get();

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      User user = User(
        uid: documentSnapshot.id,
        username: data['username'],
        email: data['email'],
        role: data['role'],
      );

      users.add(user);
    }

    return users;
  }

  Future<void> deleteUser(String uid) async {
    await _usersCollection.doc(uid).delete();
  }
}

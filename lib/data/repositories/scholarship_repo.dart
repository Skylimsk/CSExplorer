import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csexplorer/data/model/scholarship.dart';
import 'package:flutter/foundation.dart';

class ScholarshipRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addScholarship(Scholarship scholarship) async {
    try {
      await _firestore.collection('Scholarship').add(scholarship.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting scholarship infomation: $e');
      }
    }
  }

  Future<List<Scholarship>> fetchScholarshipList() async {
    try {
      final querySnapshot = await _firestore.collection('Scholarship').get();
      return querySnapshot.docs.map((doc) {
        return Scholarship.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting scholarship: $e');
      }
      return [];
    }
  }

 Future<bool> editScholarship(String scholarshipId, Scholarship editedScholarship) async {
    try {
      await _firestore.collection('Scholarship').doc(scholarshipId).update(editedScholarship.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error editing Scholarship: $e');
      }
      return false;
    }
  }

  Future<bool> deleteScholarship(String scholarshipId) async {
    try {
      await _firestore.collection('Scholarship').doc(scholarshipId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting scholarship: $e');
      }
      return false;
    }
  }

}
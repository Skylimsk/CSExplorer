import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csexplorer/data/model/university.dart';
import 'package:flutter/foundation.dart';

class UniversityRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

Future<String> addUniversity(University university) async {
  try {
    await _firestore.collection('University').add(university.toJson());
    return ''; // Return an empty string if successful
  } catch (e) {
    if (kDebugMode) {
      print('Error submitting university information: $e');
    }
    return 'An error occurred while adding university information. Please try again.'; 
  }
}



  Future<List<University>> fetchUniList() async {
    try {
      final querySnapshot = await _firestore.collection('University').get();
      return querySnapshot.docs.map((doc) {
        return University.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting university: $e');
      }
      return [];
    }
  }



  
 Future<bool> editUniversity(String universityId, University editedUniversity) async {
    try {
      await _firestore.collection('University').doc(universityId).update(editedUniversity.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error editing University: $e');
      }
      return false;
    }
  }

  
  Future<bool> deleteUniversity(String unversityId) async {
    try {
      await _firestore.collection('University').doc(unversityId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting FAQ: $e');
      }
      return false;
    }
  }

}

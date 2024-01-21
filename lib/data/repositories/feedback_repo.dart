import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csexplorer/data/model/feedback.dart';
import 'package:flutter/foundation.dart';

class FeedbackRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addFeedback(UserFeedback feedback) async {
    try {
      await _firestore.collection('Feedback').add(feedback.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting feedback form: $e');
      }
    }
  }
}

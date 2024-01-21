import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csexplorer/data/model/course.dart';
import 'package:flutter/foundation.dart';

class CourseRepo {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addCourse(Course course) async {
    try {
      await _firestore.collection('Course').add(course.toJson());
    } catch (e) {
      if (kDebugMode) {
        print('Error submitting course infomation: $e');
      }
    }
  }



  Future<List<Course>> fetchCourseList() async {
    try {
      final querySnapshot = await _firestore.collection('Course').get();
      return querySnapshot.docs.map((doc) {
        return Course.fromSnapshot(doc);
      }).toList();
    } catch (e) {
      if (kDebugMode) {
        print('Error getting course: $e');
      }
      return [];
    }
  }



  
 Future<bool> editCourse(String courseId, Course editedCourse) async {
    try {
      await _firestore.collection('Course').doc(courseId).update(editedCourse.toJson());
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error editing Course: $e');
      }
      return false;
    }
  }

  
  Future<bool> deleteCourse(String courseId) async {
    try {
      await _firestore.collection('Course').doc(courseId).delete();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting course: $e');
      }
      return false;
    }
  }

}
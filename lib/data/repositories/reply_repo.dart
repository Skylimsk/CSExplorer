import 'package:cloud_firestore/cloud_firestore.dart';

class ReplyRepository {
  Future<void> addReply(
    String reply,
  ) async {
    int like = 0;
    try {
      final CollectionReference replies =
          FirebaseFirestore.instance.collection('Reply');

      await replies.add({'reply': reply, 'likes': like});

      // ignore: avoid_print
      print('Reply added successfully!');
    } catch (e) {
      // ignore: avoid_print
      print('Error adding reply: $e');
      // Handle the error as needed
    }
  }

  static Future<List<String>> retrieveReplies() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('Reply').get();

      final List<String> comments = querySnapshot.docs
          .map((QueryDocumentSnapshot<Map<String, dynamic>> doc) =>
              doc.data()['reply'] as String)
          .toList();

      return comments;
    } catch (e) {
      // ignore: avoid_print
      print('Error retrieving comments: $e');

      return [];
    }
  }

  Future<void> incrementLikes(String comment) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Reply')
          .where('reply', isEqualTo: comment)
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await firestore.collection('Reply').doc(document.id).update({
          'likes': FieldValue.increment(1),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> incrementLikeForum(String forum) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Forum')
          .where('subject', isEqualTo: forum)
          .get();

      for (QueryDocumentSnapshot document in querySnapshot.docs) {
        await firestore.collection('Forum').doc(document.id).update({
          'likes': FieldValue.increment(1),
        });
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getLikesForum(String comment) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Forum')
          .where('subject', isEqualTo: comment)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs.first;
        int likes = document['likes'] ?? 0;
        return likes;
      } else {
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<int> getLikes(String comment) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Reply')
          .where('reply', isEqualTo: comment)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot document = querySnapshot.docs.first;
        int likes = document['likes'] ?? 0;
        return likes;
      } else {
        return 0;
      }
    } catch (e) {
      rethrow;
    }
  }
}

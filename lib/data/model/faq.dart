import 'package:cloud_firestore/cloud_firestore.dart';
class Faq {
  late String id;
  late String question;
  late String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
  }

  Faq.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        question = snapshot['question'],
        answer = snapshot['answer'];
}

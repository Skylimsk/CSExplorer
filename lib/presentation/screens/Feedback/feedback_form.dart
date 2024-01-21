import 'package:csexplorer/data/model/feedback.dart';
import 'package:csexplorer/data/repositories/feedback_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  double satisfaction = 0;
  double understanding = 0;
  double recommendability = 0;
  final _suggestionController = TextEditingController();
  final FeedbackRepository _feedbackRepository = FeedbackRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Feedback')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. How much do you enjoy using this app??',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(
              height: 10,
            ),
            RatingBar.builder(
              initialRating: 0,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 7),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return const Icon(
                      Icons.sentiment_very_dissatisfied,
                      color: Colors.red,
                    );
                  case 1:
                    return const Icon(
                      Icons.sentiment_dissatisfied,
                      color: Colors.redAccent,
                    );
                  case 2:
                    return const Icon(
                      Icons.sentiment_neutral,
                      color: Colors.amber,
                    );
                  case 3:
                    return const Icon(
                      Icons.sentiment_satisfied,
                      color: Colors.lightGreen,
                    );
                  case 4:
                    return const Icon(
                      Icons.sentiment_very_satisfied,
                      color: Colors.green,
                    );
                  default:
                    return Icon(Icons.sentiment_neutral,
                        color: Colors.grey.shade200);
                }
              },
              onRatingUpdate: (double rating) {
                satisfaction = rating;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '2. How well do you understand the concept of computer science now?',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              unratedColor: Colors.grey.shade300,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                understanding = rating;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '3. Would you recommend this app to your family or friends?',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              unratedColor: Colors.grey.shade300,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                recommendability = rating;
              },
            ),
            const SizedBox(height: 20),
            const Text(
              '4. What suggestions do you have for improving this app?',
              style: TextStyle(fontSize: 17),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _suggestionController,
              maxLines: 3,
              decoration: const InputDecoration(
                  hintText: "Your suggestions...",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  )),
            ),
            const SizedBox(height: 80),
            Center(
              child: SizedBox(
                width: 250,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    UserFeedback feedback = UserFeedback(
                      satisfaction,
                      understanding,
                      recommendability,
                      _suggestionController.text,
                    );

                    await _feedbackRepository.addFeedback(feedback);
                  },
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue[400],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: const Text('Submit'),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

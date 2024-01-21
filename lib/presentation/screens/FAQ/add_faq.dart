import 'package:flutter/material.dart';
import 'package:csexplorer/data/model/faq.dart';
import 'package:csexplorer/data/repositories/faq_repo.dart';

class AddFaqPage extends StatefulWidget {
  const AddFaqPage({Key? key}) : super(key: key);

  @override
  _AddFaqPageState createState() => _AddFaqPageState();
}

class _AddFaqPageState extends State<AddFaqPage> {
  final FaqRepository _faqRepository = FaqRepository();
  TextEditingController addQuestionController = TextEditingController();
  TextEditingController addAnswerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit University'),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Question",
                  style: TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: addQuestionController,
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Question for the FAQ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Question cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  "Answer",
                  style: TextStyle(
                    color: Color.fromARGB(255, 62, 62, 62),
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFormField(
                  controller: addAnswerController,
                  maxLines: 8,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Answer for the FAQ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Answer cannot be empty';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 50),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          String question = addQuestionController.text.trim();
                          String answer = addAnswerController.text.trim();
                          Faq newFAQ = Faq(
                            question: question,
                            answer: answer,
                          );
                          await _faqRepository.addFaq(newFAQ);
                          Navigator.pop(context, true);
                        }
                      },
                      child: const Text('Add FAQ'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.indigo[700],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

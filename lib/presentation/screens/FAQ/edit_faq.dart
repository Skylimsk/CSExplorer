import "dart:io";
import 'package:csexplorer/data/model/faq.dart';
import 'package:flutter/material.dart';
import 'package:csexplorer/data/model/faq.dart';
import 'package:csexplorer/data/repositories/faq_repo.dart';

class EditFaqPage extends StatefulWidget {
  final Faq faq;
  const EditFaqPage({required this.faq});

  @override
  _EditFaqPageState createState() => _EditFaqPageState();
}

class _EditFaqPageState extends State<EditFaqPage> {
  final FaqRepository _faqRepository = FaqRepository();
  List<Faq> faqList = [];
  TextEditingController editQuestionController = TextEditingController();
  TextEditingController editAnswerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    editQuestionController.text = widget.faq.question;
    editAnswerController.text = widget.faq.answer;
  }

  Future<void> _updateFaq() async {
    String editedQuestion = editQuestionController.text;
    String editedAnswer = editAnswerController.text;

    if (editedQuestion.isNotEmpty) {
      Faq editedfaq = Faq(question: editedQuestion, answer: editedAnswer);

      await _faqRepository.editFaq(widget.faq.id, editedfaq);
    }
  }

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Question",
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 18.0, // Adjust the font size as per your preference
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                  controller: editQuestionController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Question')),
              const SizedBox(height: 20),
              const Text(
                "Answer",
                style: TextStyle(
                  color: Color.fromARGB(255, 62, 62, 62),
                  fontSize: 18.0, // Adjust the font size as per your preference
                  fontWeight: FontWeight.bold, // Make the text bold
                ),
              ),
              const SizedBox(height: 10.0),
              TextFormField(
                  controller: editAnswerController,
                  maxLines: 8,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Answer')),
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 200,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateFaq();
                      Navigator.pop(context, true);
                    },
                    child: const Text('Save Changes'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}

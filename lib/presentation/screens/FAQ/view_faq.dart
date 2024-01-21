import 'package:flutter/material.dart';
import 'package:csexplorer/data/model/faq.dart';
import 'package:csexplorer/data/repositories/faq_repo.dart';

class ViewFAQ extends StatefulWidget {
  const ViewFAQ({Key? key}) : super(key: key);

  @override
  State<ViewFAQ> createState() => _ViewFAQState();
}

class _ViewFAQState extends State<ViewFAQ> {
  final FaqRepository _faqRepository = FaqRepository();
  List<Faq> faqList = [];

  @override
  void initState() {
    super.initState();
    _loadFaqs();
  }

  Future<void> _loadFaqs() async {
    List<Faq> faqs = await _faqRepository.getFaqs();
    setState(() {
      faqList = faqs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Padding(
            padding: EdgeInsets.only(left: 20.0,top:20), // Adjust the right padding as needed
            child: Text(
              "FAQ",
              style: TextStyle(
                 color: Colors.black,
                fontSize: 25,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.grey[100],
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: faqList.isNotEmpty
              ? ListView.builder(
                  itemCount: faqList.length,
                  itemBuilder: (context, index) {
                    return FAQTile(
                      question: faqList[index].question,
                      answer: faqList[index].answer,
                    );
                  },
                )
              : const Center(
                  child: Text(
                    'FAQ is empty',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
class FAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const FAQTile({Key? key, required this.question, required this.answer})
      : super(key: key);

  @override
  State<FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<FAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(top: 10.0, bottom: 10.0, left: 10, right: 10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 5,
      child: Theme(
        data: ThemeData(
          dividerColor: const Color.fromARGB(
              0, 240, 240, 240), // Set divider color to transparent
        ),
        child: ExpansionTile(
          title: Padding(
            padding: const EdgeInsets.only(
                top: 15.0, bottom: 15.0, left: 1.0, right: 2.0),
            child: Row(
              children: [
                Icon(
                  Icons.question_answer, // You can change this to the desired icon
                  color: Colors.indigo[700],
                ),
                const SizedBox(width: 8), // Add some space between the icon and text
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
          trailing: Icon(
            _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
          ),
          onExpansionChanged: (isExpanded) {
            setState(() {
              _isExpanded = isExpanded;
            });
          },
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 0.0, bottom: 30.0, left: 18.0, right: 18.0),
              child: Text(
                widget.answer,
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

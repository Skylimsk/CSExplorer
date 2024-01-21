import 'dart:io';

import 'package:csexplorer/data/model/scholarship.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ScholarshipDetails extends StatefulWidget {
  final Scholarship scholarshipArguments;
  const ScholarshipDetails({Key? key, required this.scholarshipArguments})
      : super(key: key);
  @override
  State<ScholarshipDetails> createState() => _ScholarshipDetailsState();
}
class _ScholarshipDetailsState extends State<ScholarshipDetails> {
 
  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw Exception('Could not launch url');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    child: _buildImageWidget(widget.scholarshipArguments.image)
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.scholarshipArguments.providerName,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.scholarshipArguments.description),
                          const SizedBox(height: 20),
                          const Text(
                            'Application Requirements',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.scholarshipArguments.applicationRequirement),
                          const SizedBox(height: 20),
                          const Text(
                            'Link to Official or Reference Website',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          GestureDetector(
                            onTap: () {
                              _launchURL(widget.scholarshipArguments.link);
                            },
                            child: Row(
                              children: [
                                const Icon(Icons.link, color: Colors.black,),
                                const SizedBox(width: 10,),
                                Expanded(
                                  child: Text(
                                    widget.scholarshipArguments.link,
                                    style: const TextStyle(
                                      color: Colors.black, // Make the link appear in a different color
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),                          
                          const SizedBox(height: 70),
                        ]),
                  ),
                ],
              ),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildImageWidget(String imagePath) {
    // ignore: unnecessary_null_comparison
    if (imagePath == null || imagePath.isEmpty) {
      return Container();
    }

    if (imagePath.startsWith('http') || imagePath.startsWith('https')) {
      return Image.network(
        imagePath,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('assets/')) {
      return Image.asset(
        imagePath,
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        File(imagePath),
        height: 150,
        width: 150,
        fit: BoxFit.cover,
      );
    }
  }


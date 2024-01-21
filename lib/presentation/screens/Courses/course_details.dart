import 'dart:io';

import 'package:csexplorer/data/model/course.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatefulWidget {
  final Course courseArguments;
  const CourseDetails({Key? key, required this.courseArguments})
      : super(key: key);
  @override
  State<CourseDetails> createState() => _CourseDetailsState();
}
class _CourseDetailsState extends State<CourseDetails> {
  List<String> courseImage = [
    'Graphic.jpg',
    'Cyber.jpg',
    'DE.png',
    'SE.jpeg',
  ];

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
                    child:_buildImageWidget(widget.courseArguments.image)
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
                            widget.courseArguments.name,
                            style: const TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 30),
                          const Text(
                            'Description',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.courseArguments.description),
                          const SizedBox(height: 30),
                          const Text(
                            'Academic Requirements',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.courseArguments.academicRequirements),
                          const SizedBox(height: 30),
                          const Text(
                            'Job Opportunities',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.courseArguments.jobOpportunity),
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
                    color: Colors.black,
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
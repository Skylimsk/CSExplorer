// adduni.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class University {
  final String uniName;
  final String description;
  final String uniCourse;

  University({
    required this.uniName,
    required this.description,
    required this.uniCourse,
  });
}

class AddUniPage extends StatefulWidget {
  @override
  _AddUniPageState createState() => _AddUniPageState();
}

class _AddUniPageState extends State<AddUniPage> {
  File? _image;
  final TextEditingController providerNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController applicationRequirementController =
      TextEditingController();

  List<University> uni = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitUniversity() {
    if (providerNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        applicationRequirementController.text.isNotEmpty) {
      setState(() {
        uni.add(
          University(
            uniName: providerNameController.text,
            description: descriptionController.text,
            uniCourse: applicationRequirementController.text,
          ),
        );
      });

      providerNameController.clear();
      descriptionController.clear();
      applicationRequirementController.clear();

      // Navigate to the third page (ScholarshipsListPage)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UniListPage(uni),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add University Page'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _submitUniversity();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: GestureDetector(
                onTap: _pickImage,
                child: _image == null
                    ? Icon(
                        Icons.add_a_photo,
                        size: 50.0,
                        color: Colors.blue,
                      )
                    : Image.file(
                        _image!,
                        width: 50.0,
                        height: 50.0,
                      ),
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: providerNameController,
              decoration: InputDecoration(
                labelText: 'University Name',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: applicationRequirementController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                labelText: 'Course Offered',
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class UniListPage extends StatelessWidget {
  final List<University> uni;

  UniListPage(this.uni);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University List'),
      ),
      body: ListView.builder(
        itemCount: uni.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(uni[index].uniName),
            subtitle: Text(uni[index].description),
            onTap: () {
              // Add navigation or details display when a scholarship is tapped
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUniPage(),
            ),
          );
        },
        tooltip: 'Add Uni',
        child: Icon(Icons.add),
      ),
    );
  }
}

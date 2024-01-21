// addscholar.dart

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class Scholarship {
  final String providerName;
  final String description;
  final String applicationRequirement;

  Scholarship({
    required this.providerName,
    required this.description,
    required this.applicationRequirement,
  });
}

class AddScholarPage extends StatefulWidget {
  @override
  _AddScholarPageState createState() => _AddScholarPageState();
}

class _AddScholarPageState extends State<AddScholarPage> {
  File? _image;
  final TextEditingController providerNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController applicationRequirementController =
      TextEditingController();

  List<Scholarship> scholarships = [];

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _submitScholarship() {
    if (providerNameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        applicationRequirementController.text.isNotEmpty) {
      setState(() {
        scholarships.add(
          Scholarship(
            providerName: providerNameController.text,
            description: descriptionController.text,
            applicationRequirement: applicationRequirementController.text,
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
          builder: (context) => ScholarshipsListPage(scholarships),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Scholar Page'),
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
              _submitScholarship();
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
                labelText: 'Scholarship Provider Name',
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
                labelText: 'Application Requirement',
              ),
            ),
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

class ScholarshipsListPage extends StatelessWidget {
  final List<Scholarship> scholarships;

  ScholarshipsListPage(this.scholarships);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarships List'),
      ),
      body: ListView.builder(
        itemCount: scholarships.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(scholarships[index].providerName),
            subtitle: Text(scholarships[index].description),
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
              builder: (context) => AddScholarPage(),
            ),
          );
        },
        tooltip: 'Add Scholar',
        child: Icon(Icons.add),
      ),
    );
  }
}

import "dart:io";

import "package:csexplorer/data/model/university.dart";
import "package:csexplorer/data/repositories/university_repo.dart";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";

class EditUniversityPage extends StatefulWidget {
  final University university;

  EditUniversityPage({required this.university});

  @override
  _EditUniversityPageState createState() => _EditUniversityPageState();
}

class _EditUniversityPageState extends State<EditUniversityPage> {
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editLocationController = TextEditingController();
  final TextEditingController editDescriptionController =TextEditingController();
  final TextEditingController editBackgroundController =TextEditingController();
  final TextEditingController editlinkController = TextEditingController();
  final TextEditingController editCourseController = TextEditingController();
  final TextEditingController editImageController = TextEditingController();
  final UniversityRepo universityRepo = UniversityRepo();

  XFile? _image;
    String imagePathAsString = "";
    Future<void> _getImage() async {
      // ignore: no_leading_underscores_for_local_identifiers
      final ImagePicker _picker = ImagePicker();
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        setState(() {
          _image = image;
          imagePathAsString = _image?.path ?? '';
        });
      }
    }

  @override
  void initState() {
    super.initState();
    editNameController.text = widget.university.name;
    editLocationController.text = widget.university.location;
    editDescriptionController.text = widget.university.description;
    editBackgroundController.text = widget.university.background;
    editlinkController.text = widget.university.link;  
    editCourseController.text = widget.university.courseNames.join('\n');
    editImageController.text = widget.university.image;
  }

  Future<void> _updateUniversity() async {
    String editedName = editNameController.text;
    String editedLocation = editLocationController.text;
    String editedDescription = editDescriptionController.text;
    String editedBackground = editBackgroundController.text;
    String editedlink = editlinkController.text;
    String editedImage = editImageController.text;



    List<String> editedCourseName = editCourseController.text.split('\n');
    if (editedName.isNotEmpty) {
      University editedUniversity = University(
        name: editedName,
        location: editedLocation,
        description: editedDescription,
        background: editedBackground,
        link: editedlink,
        courseNames: editedCourseName,
        image: editedImage,
      );

      await universityRepo.editUniversity(
          widget.university.id, editedUniversity);
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
              Text("Name", style: TextStyle(color: Colors.grey[600])),
              TextField(
                controller: editNameController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Text("Location", style: TextStyle(color: Colors.grey[600])),
              TextField(
                controller: editLocationController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Text("Description", style: TextStyle(color: Colors.grey[600])),
              TextField(
                controller: editDescriptionController,
                decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    hintText: 'Short description about the university'),
              ),
              const SizedBox(height: 20),
              Text("Introduce the university",
                  style: TextStyle(color: Colors.grey[600])),
              TextFormField(
                  controller: editBackgroundController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Background of the university')),
              const SizedBox(height: 20),
              Text(
                "Link to official or reference website",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextField(
                controller: editlinkController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            const SizedBox(height: 20),
              Text("Update image of the university",
                style: TextStyle(color: Colors.grey[600]
                ),
             ),
             const SizedBox(height: 5),
              Container(
                height: 100,
                width: double.infinity, // Make the button full width
                child: _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(
                          File(_image!.path),
                          fit: BoxFit.cover,
                          width: 80,
                          height: 80,
                        ),
                      )
                    : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.grey.shade600, 
                          width: 1.0, 
                        ),
                      ),
                      child: Material(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          child: InkWell(
                            onTap: _getImage,
                            borderRadius: BorderRadius.circular(10),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.image,
                                    color: Colors.indigo.shade700
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Select Image",
                                    style: TextStyle(
                                      color: Colors.indigo.shade700,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ),
              ),
              const SizedBox(height: 20),
              Text("Number of computer science courses offered",
                  style: TextStyle(color: Colors.grey[600])),
              TextFormField(
                  controller: editCourseController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Course of the university')),
              const SizedBox(height: 80),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateUniversity();
                      Navigator.pop(context, true);
                    },
                    child: Text('Save Changes'),
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

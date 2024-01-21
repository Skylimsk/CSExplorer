import 'dart:io';

import 'package:csexplorer/data/model/course.dart';
import 'package:csexplorer/data/repositories/course_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditCoursePage extends StatefulWidget {
  final Course course;
  EditCoursePage({required this.course});

  @override
  _EditCoursePageState createState() => _EditCoursePageState();
}

class _EditCoursePageState extends State<EditCoursePage> {
  final TextEditingController editNameController = TextEditingController();
  final TextEditingController editDescriptionController = TextEditingController();
  final TextEditingController editAcademicReqController = TextEditingController();
  final TextEditingController editJobOpportunityController = TextEditingController();
  final TextEditingController editImageController = TextEditingController();

  final CourseRepo courseRepo = CourseRepo();

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
    editNameController.text = widget.course.name;
    editDescriptionController.text = widget.course.description;
    editAcademicReqController.text = widget.course.academicRequirements;
    editJobOpportunityController.text = widget.course.jobOpportunity;
    editImageController.text = widget.course.image;
  }

  Future<void> _updateCourse() async {
    String editedName = editNameController.text;
    String editedDescription = editDescriptionController.text;
    String editedAcademicReq = editAcademicReqController.text;
    String editedJobOpportunity = editJobOpportunityController.text;
    String editedImage = editImageController.text;

    if (editedName.isNotEmpty) {
      Course editedCourse = Course(
        name: editedName,
        description: editedDescription,
        academicRequirements: editedAcademicReq,
        jobOpportunity: editedJobOpportunity,
        image: editedImage
      );

      await courseRepo.editCourse(
          widget.course.id, editedCourse);
    }
  }


  @override
   Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit a course"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Course Name",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextField(
                controller: editNameController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 20),
              Text(
                "Description",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextFormField(
                  controller: editDescriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Description of the course')),
              const SizedBox(height: 20),
              Text("Academic Requirements",
                  style: TextStyle(color: Colors.grey[600])),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                  controller: editAcademicReqController,
                  maxLines: 5,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      hintText: 'Any specific knowledge or skills requirements')),
              const SizedBox(height: 20),
              Text(
                "Job Opportunities",
                style: TextStyle(color: Colors.grey[600]),
              ),
              TextField(
                controller: editJobOpportunityController,
                decoration:
                    const InputDecoration(border: UnderlineInputBorder()),
              ),
            const SizedBox(height: 20),
            Text("Update image or clipart of the course",
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
              const SizedBox(height: 50),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _updateCourse();
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
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  
  }
}
 
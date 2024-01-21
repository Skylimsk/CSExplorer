import 'dart:io';

import 'package:csexplorer/data/model/course.dart';
import 'package:csexplorer/data/repositories/course_repo.dart';
import 'package:csexplorer/service/Validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class CourseForm extends StatefulWidget {
  const CourseForm({super.key});
  @override
  State<CourseForm> createState() => _UniversityFormState();
}
class _UniversityFormState extends State<CourseForm> {
  final _courseController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _academicReqController = TextEditingController();
  final _jobOpportunityController = TextEditingController();

  final CourseRepo _courseRepository = CourseRepo();

  final _formkey = GlobalKey<FormState>();

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a course"),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Form(
          key: _formkey,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      "Course Name",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)
                  ],
                ),
                TextFormField(
                  controller: _courseController,
                  validator: (value) => Validator.validateCourseName(value!),
                  decoration:
                      const InputDecoration(border: UnderlineInputBorder()),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Description",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)                  ],
                ),
                TextFormField(
                    controller: _descriptionController,
                    validator: (value) => Validator.validateDescription(value!),
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Description of the course')),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text("Academic Requirements",
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                    controller: _academicReqController,
                    validator: (value) => Validator.validateAcademicReq(value!),
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Any specific knowledge or skills requirements')),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Job Opportunities",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)                  ],
                ),
                TextFormField(
                  controller: _jobOpportunityController,
                  validator: (value) => Validator.validateJobOpportunity(value!),
                  decoration:
                      const InputDecoration(border: UnderlineInputBorder()),
                ),
              const SizedBox(height: 20),
              Text("Upload image of the scholarship provider",
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
                        if(_formkey.currentState!.validate()){
                          Course course = Course(
                              name:_courseController.text,
                              description:_descriptionController.text,
                              academicRequirements: _academicReqController.text,
                              jobOpportunity:_jobOpportunityController.text,
                              image: imagePathAsString,
                              );
            
                          _courseRepository.addCourse(course);
                          Navigator.pop(context);
                        }                       
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.indigo[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text('Submit'),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  
  }
}



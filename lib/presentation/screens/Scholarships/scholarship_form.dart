import 'dart:io';

import 'package:csexplorer/data/model/scholarship.dart';
import 'package:csexplorer/data/repositories/scholarship_repo.dart';
import 'package:csexplorer/service/Validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScholarshipForm extends StatefulWidget {
  const ScholarshipForm({super.key});
  @override
  State<ScholarshipForm> createState() => _ScholarshipFormState();
}
class _ScholarshipFormState extends State<ScholarshipForm> {
  final _providerNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _applicationReqController = TextEditingController();
  final _linkController = TextEditingController();

  final ScholarshipRepo _scholarshipRepository = ScholarshipRepo();

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
        title: const Text("Add a scholarship"),
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
                      "Scholarship Provider Name",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)                  ],
                ),
                TextFormField(
                  controller: _providerNameController,
                  validator: (value) => Validator.validateProviderName(value!),
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
                  ],
                ),
                TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Description of the scholarship')),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text("Application Requirements",
                        style: TextStyle(color: Colors.grey[600])),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                TextFormField(
                    controller: _applicationReqController,
                    validator: (value) => Validator.validateReq(value!),
                    maxLines: 5,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        hintText: 'Any specific academic or financial requirements')),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text(
                      "Link to official or reference website",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 5,),
                    const Text("*", style: TextStyle(color: Colors.red),)                  ],
                ),
                TextFormField(
                  controller: _linkController,
                  validator: (value) => Validator.validateLink(value!),
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
                        if (_formkey.currentState!.validate()) {
                          Scholarship scholarship = Scholarship(
                              providerName: _providerNameController.text,
                              description:_descriptionController.text,
                              applicationRequirement: _applicationReqController.text,
                              link: _linkController.text, 
                              image: imagePathAsString,
                              );
          
                          _scholarshipRepository.addScholarship(scholarship);
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
import 'dart:io';

import 'package:csexplorer/data/model/forum.dart';
import 'package:csexplorer/data/repositories/forum_repo.dart';
import 'package:csexplorer/service/authService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ForumTopicForm extends StatefulWidget {
  const ForumTopicForm({super.key});

  @override
  State<ForumTopicForm> createState() => _ForumTopicFormState();
}

class _ForumTopicFormState extends State<ForumTopicForm> {
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final ForumRepository _forumRepository = ForumRepository();
  List<String> likeId = [];
  String userId = AuthService.getCurrentUserId();
  String name = "";
  XFile? _image;
  String imagePathAsString = "";
  List<String> existingSubjects = [];


  Future<void> _getImage() async
  {
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

  Future<void> retrieveId() async {
    existingSubjects = await ForumRepository.fetchForumSubjects();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    initializeName();
    retrieveId();
  }

  Future<void> initializeName() async {
    // ignore: await_only_futures
    print("id,$userId");
    name = await AuthService.getUserNameById(userId);
    print("name,$name");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a topic"),
      ),
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Subject"),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a subject';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const Text("Message"),
              const SizedBox(
                height: 5,
              ),
              TextFormField(
                controller: _messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a message';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              const Text("Upload Image"),
              const SizedBox(
                height: 5,
              ),
              _image != null
                  ? Image.file(
                      File(_image!.path),
                      height: 100,
                    )
                  : ElevatedButton(
                      onPressed: _getImage,
                      child: const Text("Select Image"),
                    ),
              const SizedBox(height: 156),
              Center(
                child: SizedBox(
                  width: 250,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_subjectController.text.isEmpty ||
                          _messageController.text.isEmpty)
                      {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Subject or Message cannot be empty.'),
                          ),
                        );
                      } else {
                        String enteredSubject = _subjectController.text;
                        if (existingSubjects.contains(enteredSubject)) {
                          // Subject already exists, show error message
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Subject already exists. Please choose a different subject.'),
                            ),
                          );
                        } else {
                         
                          Forum forum = Forum(
                            enteredSubject,
                            _messageController.text,
                            userId,
                            name,
                            imagePathAsString,likeId
                          );
                          _forumRepository.addForumTopic(forum);
                          Navigator.pop(context);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Submit'),
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



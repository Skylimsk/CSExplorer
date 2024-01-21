import "dart:io";

import "package:csexplorer/customWidget/CustomAppBar.dart";
import "package:csexplorer/data/model/university.dart";
import "package:csexplorer/data/repositories/university_repo.dart";
import "package:csexplorer/presentation/screens/Universities/university_details.dart";
import "package:csexplorer/presentation/screens/Universities/university_form.dart";
import "package:csexplorer/presentation/screens/Universities/edit_university.dart";
import "package:flutter/material.dart";

class ManageUniversity extends StatefulWidget {
  const ManageUniversity({super.key});

  @override
  State<ManageUniversity> createState() => _UniversityMainState();
}

class _UniversityMainState extends State<ManageUniversity> {
  final UniversityRepo universityRepo = UniversityRepo();
  List<University> universities = [];

  @override
  void initState() {
    super.initState();
    _loadUniversity();
  }

  Future<void> _loadUniversity() async {
    List<University> fetchedUniversities = await universityRepo.fetchUniList();
    setState(() {
      universities = fetchedUniversities;
    });
  }

  void _deleteUniversity(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this university?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
               style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                bool success = await universityRepo.deleteUniversity(universities[index].id);
                if (success) {
                  _loadUniversity();
                } else {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Cannot Delete the University'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                }
                Navigator.of(context).pop(); // Close the confirmation dialog
              },
               style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.indigo[700],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void editUniversity(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditUniversityPage(university: universities[index]),
      ),
    ).then((_) {
      _loadUniversity();
    });
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: CustomAppBar(
        title: "Tertiary Institution",
        description: "Public and Private University/College/Vocational",
        colour: Colors.indigo.shade700),
    backgroundColor: Colors.grey[100],
    body: ListView.separated(
      itemCount: universities.length,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      separatorBuilder: (context, index) => const SizedBox(
        height: 10,
      ),
      itemBuilder: (context, index) {
        University university = universities[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UniversityDetails(universityArguments: university),
              ),
            );
          },
          child: Container(
            width: 240,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildImageWidget(university.image),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15, vertical: 15),
                  child: SizedBox(
                    height: 100,
                    width: 230,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          university.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Add your edit and delete icons here
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        editUniversity(context, index);
                                      }),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                    ),
                                    color: const Color.fromARGB(
                                        255, 251, 117, 117),
                                    onPressed: () {
                                      _deleteUniversity(index);
                                    },
                                  ),
                                ],
                              ),
                              Text(university.description),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
    floatingActionButton: Stack(
      children: [
        Positioned(
          bottom: 60,
          right: 10,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UniversityForm()));
            },
            backgroundColor: Colors.indigo[700],
            elevation: 0,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
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
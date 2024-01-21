import "dart:io";

import "package:csexplorer/customWidget/CustomAppBar.dart";
import "package:csexplorer/data/model/course.dart";
import "package:csexplorer/data/repositories/course_repo.dart";
import "package:csexplorer/presentation/screens/Courses/course_details.dart";
import "package:csexplorer/presentation/screens/Courses/courses_form.dart";
import "package:csexplorer/presentation/screens/Courses/edit_course.dart";
import "package:flutter/material.dart";


class ManageCourse extends StatefulWidget {
  const ManageCourse({super.key});
  @override
  State<ManageCourse> createState() => _ManageCourseState();
}

class _ManageCourseState extends State<ManageCourse> {
  final CourseRepo courseRepo = CourseRepo();
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();
    _loadCourse();
  }

  Future<void> _loadCourse() async {
    List<Course> courseList = await courseRepo.fetchCourseList();
    setState(() {
      courses = courseList;
    });
  }
  
  void _deleteCourse(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this course?'),
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
                bool success = await courseRepo.deleteCourse(courses[index].id);
                if (success) {
                  _loadCourse();
                } else {
                  // ignore: use_build_context_synchronously
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Error'),
                        content: const Text('Cannot Delete this Course'),
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

  void editCourse(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCoursePage(course: courses[index]),
      ),
    ).then((_) {
      _loadCourse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Courses",
        description: "Computer Science courses and its description",
        colour: Colors.indigo.shade700,
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Course>>(
        future: courseRepo.fetchCourseList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error fetching data'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No course found'),
            );
          } else {
              return ListView.separated(
                    itemCount: snapshot.data!.length,
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    separatorBuilder: (context, index) => const SizedBox(
                      height: 10,
                    ),
                    itemBuilder: (context, index) {
                      Course course = courses[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => CourseDetails(
                                                courseArguments: course)));
                                  },
                                  child: Container(
                                    width: 240,
                                    height: 120,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(15)),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(left: 20),
                                          child: Container(
                                            width: 80,
                                            height: 80,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.circular(10),
                                              child:_buildImageWidget(course.image)
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
                                                        course.name,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold, 
                                                            fontSize: 13.0),
                                                      ),
                                                      const SizedBox(
                                                        height: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // Add your edit and delete icons here
                                                IconButton(
                                                    icon: const Icon(Icons.edit),
                                                    onPressed: () {
                                                      editCourse(context, index);
                                                    }),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.delete,
                                                  ),
                                                  color: const Color.fromARGB(
                                                      255, 251, 117, 117),
                                                  onPressed: () {
                                                    _deleteCourse(index);
                                                  },
                                                ),
                                              ],
                                            ),
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
                  );
          }
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
                    builder: (context) => const CourseForm(),
                  ),
                );
              },
              backgroundColor: Colors.indigo.shade700,
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
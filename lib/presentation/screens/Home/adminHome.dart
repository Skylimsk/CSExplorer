import "package:csexplorer/customWidget/CustomHomeContainer.dart";
import "package:csexplorer/presentation/screens/Courses/manage_course.dart";
import "package:csexplorer/presentation/screens/Scholarships/manage_scholarship.dart";
import "package:csexplorer/presentation/screens/Universities/manage_university.dart";
import 'package:csexplorer/presentation/screens/userList/user_list_screen.dart';
import "package:csexplorer/service/authService.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _HomeState();
}

class _HomeState extends State<AdminHome> {
  final AuthService _authService = AuthService();
  Map<String, dynamic>? userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  _loadUserData() async {
    User? user = await _authService.getCurrentUser();
    if (user != null) {
      Map<String, dynamic>? data = await _authService.getUserData(user.uid);
      if (mounted) {
        setState(() {
          userData = data;
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isLoading
            ? const CircularProgressIndicator() // Show loading indicator
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hi, ${userData!['username']}",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Have a great day today",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
        backgroundColor: Colors.indigo[700],
        toolbarHeight: 100,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Manage Computer Science Information",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              CustomHomeContainer(
                link: 'assets/images/main/tertiaryEducation.jpg',
                title: "Tertiary Institution",
                description:
                    "list of public and private universities, colleges, and vocational schools that provide computer science",
                onTapCallback: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageUniversity()));
                },
              ),
              const SizedBox(height: 15),
              CustomHomeContainer(
                link: 'assets/images/main/computerScience.jpg',
                title: "Computer Science Courses",
                description:
                    "Type of computer science courses and its details",
                onTapCallback: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageCourse()));
                },
              ),
              const SizedBox(height: 15),
              CustomHomeContainer(
                link: 'assets/images/main/scholarship.jpg',
                title: "Scholarships",
                description:
                    "Scholarship that can aid your tertiary studies",
                onTapCallback: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageScholarship()));
                },
              ),
              const SizedBox(height: 20),
              const Text(
                "View The User List",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),
              CustomHomeContainer(
                link: 'assets/images/main/user.png',
                title: "List of Users",
                description:
                    "View list of users that have account for the application",
                onTapCallback: (context) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const userListScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
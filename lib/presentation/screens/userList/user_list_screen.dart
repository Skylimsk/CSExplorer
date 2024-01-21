// ignore_for_file: camel_case_types, use_build_context_synchronously

import 'package:csexplorer/data/model/user.dart';
import 'package:csexplorer/data/repositories/user_repo.dart';
import 'package:flutter/material.dart';

class userListScreen extends StatefulWidget {
  const userListScreen({super.key});

  @override
  State<userListScreen> createState() => _userListScreenState();
}

class _userListScreenState extends State<userListScreen> {
  final UserRepository _userRepository = UserRepository();
  bool isLoading = true;
  List<User> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
    });

    try {
      users = await UserRepository()
          .getUsersByRole('user'); // Replace 'admin' with the target role
    } catch (error) {
      print('Error loading users: $error');
      // Handle error as needed
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _deleteUser(String userId) async {
    try {
      await _userRepository.deleteUser(userId);
      _loadUsers();
    } catch (error) {
      print('Error deleting user: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 360,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.white10), // Set border properties here
                    borderRadius: BorderRadius.circular(
                        8.0), // Optional: Set border radius
                  ),
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: ListTile(
                    title: Text(users[index].username),
                    subtitle: Text(users[index].email),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Delete User's Account?"),
                              content: const Text(
                                  '''If you select "Delete" Your app data will also be deleted and you won't be able to retrieve it.

Confirm to delete the account?.'''),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                TextButton(
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () async {
                                    _deleteUser(users[index].uid);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}

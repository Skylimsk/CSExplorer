import 'package:csexplorer/presentation/screens/Authentication/login.dart';
import 'package:csexplorer/presentation/screens/MBTI/mbti.dart';
import 'package:csexplorer/presentation/screens/Profile/change_password.dart';
import 'package:csexplorer/service/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
        title: const Text("Profile"),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  Container(
                    width: 360,
                    height: 170,
                    decoration: BoxDecoration(
                      color: Colors.indigo[700],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Get to Know Your",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(224, 224, 224, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            "Own Strength",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromRGBO(224, 224, 224, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 25),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CheckMbtiPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Do MBTi Test >>',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                decorationColor:
                                    Color.fromRGBO(224, 224, 224, 1),
                                decorationThickness: 2.0,
                                color: Color.fromRGBO(224, 224, 224, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    width: 360,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: const Text(
                        'Name',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        '${userData!['username']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 360,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: const Text(
                        'Email',
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        '${userData!['email']}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 360,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: const Text('Change Password'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.edit,
                          size: 30,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangePassword(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    width: 360,
                    height: 70,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: const Text('Delete Account'),
                      trailing: IconButton(
                        icon: Icon(
                          Icons.delete,
                          size: 30,
                          color: Colors.grey.withOpacity(0.8),
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Delete your Account?'),
                                content: const Text(
                                    '''If you select "Delete" Your app data will also be deleted and you won't be able to retrieve it.

Confirm to delete your account?.'''),
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
                                      await _authService.deleteAccount();
                                      Navigator.of(context, rootNavigator: true)
                                          .pushAndRemoveUntil(
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      const LoginPage(
                                                        title: 'Sign in',
                                                      )),
                                              (route) => false);
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        foregroundColor: Colors.grey[100],
                        backgroundColor: Colors.indigo[700],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: () async {
                        await _authService.logOut();
                        Navigator.of(context, rootNavigator: true)
                            .pushAndRemoveUntil(
                                CupertinoPageRoute(
                                    builder: (context) => const LoginPage(
                                          title: 'Sign in',
                                        )),
                                (route) => false);
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Future<String?> getUserEmail() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      // The user is signed in
      return user.email;
    } else {
      // The user is not signed in
      return null;
    }
  }
}

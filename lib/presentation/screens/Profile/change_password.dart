import 'package:csexplorer/service/Validator.dart';
import 'package:csexplorer/service/authService.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ChangePassword> {
  final AuthService _authService = AuthService();

  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color.fromRGBO(245, 245, 245, 1),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            );
          },
        ),
        elevation: 4,
        backgroundColor: Colors.indigo[700],
      ),
      body: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
              child: Text(
                "Reset Password",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 27),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 35, vertical: 5),
              child: Text(
                "Please enter your email to reset your password",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 30),
              child: TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  hintText: 'name@email.com',
                  labelText: 'Enter your email',
                ),
                validator: (value) => Validator.validateEmail(value!),
              ),
            ),
            const SizedBox(
              height: 300,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
              child: Center(
                child: SizedBox(
                  height: 50,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formkey.currentState!.validate()) {
                        String email = emailController.text;
                        resetPassword(email);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please fill input')));
                      }
                    },
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
                    child: const Text('Reset Password'),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void resetPassword(String email) async {
    const CircularProgressIndicator();
    if (_formkey.currentState!.validate()) {
      try {
        await _authService.resetPassword(email);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password Reset Email Sent')));
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        print(e);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Invalid Email')));
      }
    }
  }
}

//import 'package:csexplorer/bottom_navbar.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:csexplorer/firebase_config.dart';
import 'package:csexplorer/presentation/screens/Authentication/login.dart';
import 'package:csexplorer/splash.dart';
//import 'package:csexplorer/presentation/screens/Authentication/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseConfig.platformOptions);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.grey[100],
          primaryColor: Colors.indigo[700]),
      home: AnimatedSplashScreen(
        backgroundColor: Colors.blue.shade50,
        splash: Center(
          child: SizedBox(
            height: 800,
            width: 150,
            child: Image.asset(
              'assets/images/CSExplorer.jpeg', 
              fit: BoxFit.cover,
            ),
          ),
        ),
        nextScreen: const LoginPage(title: 'Sign In'),
        splashTransition: SplashTransition.fadeTransition,
      ),   
    );
  }
}

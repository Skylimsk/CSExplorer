import 'package:csexplorer/presentation/screens/Authentication/login.dart';
import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      body: Center(
        child: Container(
          child: Image.asset('assets/images/CSExplorer.jpeg', 
            height: 350,
            width: 350,
            fit: BoxFit.cover,), 
           ),
      ),
    );
  }
}
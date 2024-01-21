import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckMbtiPage(),
    );
  }
}

class CheckMbtiPage extends StatelessWidget {
  CheckMbtiPage({Key? key}) : super(key: key);

  final Uri _url =
      Uri.parse('https://www.16personalities.com/free-personality-test');

  Future<void> _launchUrl(url) async {
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Expanded(
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "MBTI test",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                   fontSize: 25,
                ),
              ),
              SizedBox(height: 7),
              Text(
                "Get to know your personality with the MBTI test",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.indigo[700],
        toolbarHeight: 160,
        shape: const ContinuousRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 15.0, horizontal: 35.0),
                child: Text(
                  '16 characters of Meyers-Briggs Type Indicator',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.indigo[700],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              const Center(
                child: Image(
                  image: AssetImage('assets/images/mbti/mbti.png'),
                  width: 350,
                  height: 350,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30.0),
              Center(
                // Centering the button
                child: ElevatedButton(
                  onPressed: () {
                    _launchUrl(_url);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    backgroundColor: Colors.indigo[700],
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25.0),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link, color: Colors.white),
                      SizedBox(width: 10),
                      Text('Do MBTI Test'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30.0),
            ],
          ),
        ),
      ),
    );
  }
}

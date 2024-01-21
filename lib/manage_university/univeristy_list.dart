// scholarships_list.dart

import 'adduni.dart';
import 'package:flutter/material.dart';

class University {
  final String uniName;
  final String description;
  final String uniCourse;

  University({
    required this.uniName,
    required this.description,
    required this.uniCourse,
  });
}

class UniListPage extends StatelessWidget {
  final List<University> uni;

  UniListPage(this.uni);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('University List'),
      ),
      body: ListView.builder(
        itemCount: uni.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(uni[index].uniName),
            subtitle: Text(uni[index].description),
            onTap: () {
              // Add navigation or details display when a scholarship is tapped
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddUniPage(),
            ),
          );
        },
        tooltip: 'Add University',
        child: Icon(Icons.add),
      ),
    );
  }
}

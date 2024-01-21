// scholarships_list.dart

import 'addscholar.dart';
import 'package:flutter/material.dart';

class Scholarship {
  final String providerName;
  final String description;
  final String applicationRequirement;

  Scholarship({
    required this.providerName,
    required this.description,
    required this.applicationRequirement,
  });
}

class ScholarshipsListPage extends StatelessWidget {
  final List<Scholarship> scholarships;

  ScholarshipsListPage(this.scholarships);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scholarships List'),
      ),
      body: ListView.builder(
        itemCount: scholarships.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(scholarships[index].providerName),
            subtitle: Text(scholarships[index].description),
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
              builder: (context) => AddScholarPage(),
            ),
          );
        },
        tooltip: 'Add Scholar',
        child: Icon(Icons.add),
      ),
    );
  }
}

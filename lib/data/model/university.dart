import 'package:cloud_firestore/cloud_firestore.dart';

class University {
  late String id;
  late String name, location, description, background, link;
  late List<String> courseNames;
  late String image;

  University({
    required this.name,
    required this.location,
    required this.description,
    required this.background,
    required this.link,
    required this.image,
    List<String>? courseNames,
  }) : this.courseNames = courseNames ?? <String>[];

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'location': location,
      'description': description,
      'background': background,
      'link':link,
      'courseNames': courseNames,
      'image': image,
    };
  }

  University.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        location = json['location'],
        description = json['description'],
        background = json['background'],
        link = json['link'],
        image = json['image'],
        courseNames = List<String>.from(json['courseNames'] ?? []);

  University.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        location = snapshot['location'],
        description = snapshot['description'],
        background = snapshot['background'],
        link = snapshot['link'],
        image = snapshot['image'],
        courseNames = List<String>.from(snapshot['courseNames'] ?? []);
}

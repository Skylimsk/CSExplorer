import 'package:cloud_firestore/cloud_firestore.dart';

class Course{
  late String id;
  late String name, description, academicRequirements, jobOpportunity;
  late String image;


  Course({
    required this.name,
    required this.description,
    required this.academicRequirements,
    required this.jobOpportunity,
    required this.image,
  }); 

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'academicRequirements': academicRequirements,
      'jobOpportunity': jobOpportunity,
      'image': image,
    };
  }

  Course.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        academicRequirements = json['academicRequirements'],
        jobOpportunity= json['jobOpportunity'],
        image = json['image'];        

  Course.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        name = snapshot['name'],
        description = snapshot['description'],
        academicRequirements = snapshot['academicRequirements'],
        jobOpportunity= snapshot['jobOpportunity'],
        image= snapshot['image'];
}
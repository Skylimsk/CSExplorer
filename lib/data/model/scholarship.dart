import 'package:cloud_firestore/cloud_firestore.dart';

class Scholarship {
  late String providerName;
  late String description;
  late String applicationRequirement;
  late String id;
  late String link;
  late String image;



  Scholarship({
    required this.providerName,
    required this.description,
    required this.applicationRequirement,
    required this.link,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'providerName': providerName,
      'description': description,
      'applicationRequirement': applicationRequirement,
      'link': link,
      'image': image,
    };
  }

  Scholarship.fromJson(Map<String, dynamic> json)
      : providerName = json['providerName'],
        description = json['description'],
        applicationRequirement= json['applicationRequirement'],
        link = json['link'],
        image = json['image']; 
        
        

  Scholarship.fromSnapshot(DocumentSnapshot snapshot)
      : id = snapshot.id,
        providerName = snapshot['providerName'],
        description = snapshot['description'],
        applicationRequirement = snapshot['applicationRequirement'],
        link = snapshot['link'],
        image= snapshot['image'];
}
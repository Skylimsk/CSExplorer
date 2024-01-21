class Forum {
  late String subject, message;
  late String id;
  late String name;
  late String image;
  late List<String> likeId = [];

  Forum(this.subject, this.message, this.id, this.name, this.image,
     this.likeId );

  Forum.copy(Forum item)
      : this(item.subject, item.message, item.id, item.name,
            item.image,item.likeId);

  Map<String, dynamic> toJson() {
    return {
      'subject': subject,
      'message': message,
      'id': id,
      'name': name,
      'image': image,
      'likeId': likeId
    };
  }

  Forum.fromJson(Map<String, dynamic> json) {
    subject = json['subject'];
    message = json['message'];
    id = json['id'];
    name = json['name'];
    image = json['image'];
    likeId = List<String>.from(json['likeId'] ?? []);
  }

}
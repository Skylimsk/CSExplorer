class Reply {
  String reply;
  String name;
  String id;
  late List<String> likeId = [];

  Reply(this.reply, this.name, this.id, this.likeId);

  Reply.copy(Reply item)
      : this(item.reply, item.name, item.id, item.likeId);

  Map<String, dynamic> toJson() {
    return {
      'reply': reply,
      'name': name,
      'id': id,
      'likeId': likeId
    };
  }

  Reply.fromJson(Map<String, dynamic> json)
      : reply = json['reply'] ?? '',
        name = json['name'] ?? '',
        id = json['id'] ?? '',
        likeId = json['likeId'] ?? '';
}

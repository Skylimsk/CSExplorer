class UserFeedback {
  late double satisfaction;
  late double understanding;
  late double recommendability;
  late String suggestion;

  UserFeedback(this.satisfaction, this.understanding, this.recommendability,
      this.suggestion);

  // using dart initializer list to write copy constructor instead
  // this.item= item.satisfaction
  UserFeedback.copy(UserFeedback item)
      : this(item.satisfaction, item.understanding, item.recommendability,
            item.suggestion);

  // serialization
  Map<String, dynamic> toJson() {
    return {
      'satisfaction': satisfaction,
      'understanding': understanding,
      'recommendability': recommendability,
      'suggestion': suggestion,
    };
  }

  // deserialization
  UserFeedback.fromJson(Map<String, dynamic> json) {
    satisfaction = json['satisfaction'];
    understanding = json['understanding'];
    recommendability = json['recommendability'];
    suggestion = json['suggestion'];
  }
  
}

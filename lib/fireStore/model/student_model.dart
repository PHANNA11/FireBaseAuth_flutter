class Student {
  late int id;
  late String name;
  late String gender;
  late double score;
  Student(
      {required this.id,
      required this.name,
      required this.gender,
      required this.score});
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'score': score,
    };
  }

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        gender = json['gender'],
        score = json['score'];
}

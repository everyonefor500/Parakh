class Rule {
  final String id;
  final String ruleNumber;
  final String title;
  final String description;
  final String category;

  Rule({
    required this.id,
    required this.ruleNumber,
    required this.title,
    required this.description,
    required this.category,
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      id: json['id'],
      ruleNumber: json['ruleNumber'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'ruleNumber': ruleNumber,
      'title': title,
      'description': description,
      'category': category,
    };
  }
}

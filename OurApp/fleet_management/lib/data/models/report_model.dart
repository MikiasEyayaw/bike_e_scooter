class Report {
  final String id;
  final String type;
  final String description;
  final DateTime createdAt;

  Report({
    required this.id,
    required this.type,
    required this.description,
    required this.createdAt,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
    id: json['id'] ?? '',
    type: json['type'] ?? '',
    description: json['description'] ?? '',
    createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'description': description,
    'createdAt': createdAt.toIso8601String(),
  };
}

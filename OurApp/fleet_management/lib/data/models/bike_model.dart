class Bike {
  final String id;
  final String name;
  final String status;

  Bike({required this.id, required this.name, required this.status});

  factory Bike.fromJson(Map<String, dynamic> json) => Bike(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    status: json['status'] ?? 'unknown',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'status': status,
  };
}

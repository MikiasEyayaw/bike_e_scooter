class Scooter {
  final String id;
  final String name;
  final double batteryLevel;

  Scooter({
    required this.id,
    required this.name,
    required this.batteryLevel,
  });

  factory Scooter.fromJson(Map<String, dynamic> json) => Scooter(
    id: json['id'] ?? '',
    name: json['name'] ?? '',
    batteryLevel: (json['batteryLevel'] ?? 0).toDouble(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'batteryLevel': batteryLevel,
  };
}

class Maintenance {
  final String id;
  final String vehicleId;
  final String issue;
  final String status;

  Maintenance({
    required this.id,
    required this.vehicleId,
    required this.issue,
    required this.status,
  });

  factory Maintenance.fromJson(Map<String, dynamic> json) => Maintenance(
    id: json['id'] ?? '',
    vehicleId: json['vehicleId'] ?? '',
    issue: json['issue'] ?? '',
    status: json['status'] ?? 'pending',
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicleId': vehicleId,
    'issue': issue,
    'status': status,
  };
}

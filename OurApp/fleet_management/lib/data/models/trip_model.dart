class Trip {
  final String id;
  final String vehicleId;
  final DateTime startTime;
  final DateTime? endTime;

  Trip({
    required this.id,
    required this.vehicleId,
    required this.startTime,
    this.endTime,
  });

  factory Trip.fromJson(Map<String, dynamic> json) => Trip(
    id: json['id'] ?? '',
    vehicleId: json['vehicleId'] ?? '',
    startTime: DateTime.tryParse(json['startTime'] ?? '') ?? DateTime.now(),
    endTime: json['endTime'] != null
        ? DateTime.tryParse(json['endTime'])
        : null,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'vehicleId': vehicleId,
    'startTime': startTime.toIso8601String(),
    'endTime': endTime?.toIso8601String(),
  };
}

class AnalyticsModel {
  final int totalVehicles;
  final int totalUsers;
  final int activeUsers;
  final double maintenanceCompletionRate;

  /// Breakdown data (for pie & bar charts)
  final Map<String, int> maintenanceCountByType;

  AnalyticsModel({
    required this.totalVehicles,
    required this.totalUsers,
    required this.activeUsers,
    required this.maintenanceCompletionRate,
    required this.maintenanceCountByType,
  });

  /// Convert to JSON (useful for APIs or persistence)
  Map<String, dynamic> toJson() => {
    'totalVehicles': totalVehicles,
    'totalUsers': totalUsers,
    'activeUsers': activeUsers,
    'maintenanceCompletionRate': maintenanceCompletionRate,
    'maintenanceCountByType': maintenanceCountByType,
  };

  /// Load from JSON
  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalVehicles: json['totalVehicles'] ?? 0,
      totalUsers: json['totalUsers'] ?? 0,
      activeUsers: json['activeUsers'] ?? 0,
      maintenanceCompletionRate:
      (json['maintenanceCompletionRate'] ?? 0.0).toDouble(),
      maintenanceCountByType:
      Map<String, int>.from(json['maintenanceCountByType'] ?? {}),
    );
  }
}

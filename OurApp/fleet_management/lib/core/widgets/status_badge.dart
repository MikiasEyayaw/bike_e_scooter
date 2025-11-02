// status_badge.dart
import 'package:flutter/material.dart';

class StatusBadge extends StatelessWidget {
  final String status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) => Chip(
    label: Text(status),
    backgroundColor:
    status.toLowerCase() == 'active' ? Colors.green : Colors.grey,
  );
}

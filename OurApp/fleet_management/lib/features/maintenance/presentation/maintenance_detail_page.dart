import 'package:flutter/material.dart';

class MaintenanceDetailPage extends StatelessWidget {
  final String taskName;

  const MaintenanceDetailPage({super.key, required this.taskName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(taskName)),
      body: Center(
        child: Text(
          'Details for $taskName',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

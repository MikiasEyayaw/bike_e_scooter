import 'package:flutter/material.dart';

import 'maintenance_detail_page.dart';

class MaintenanceListPage extends StatelessWidget {
  const MaintenanceListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final tasks = ["Bike 001 - Brake Check", "Scooter 102 - Battery"];
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance")),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(tasks[index]),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MaintenanceDetailPage(taskName: tasks[index]),
            ),
          ),
        ),
      ),
    );
  }
}



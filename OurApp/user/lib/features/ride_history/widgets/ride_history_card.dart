import 'package:flutter/material.dart';

class RideHistoryCard extends StatelessWidget {
  const RideHistoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ListTile(
        title: const Text('Ride #1234'),
        subtitle: const Text('Completed on 2025-10-31'),
        trailing: const Text('ETB 45.00'),
      ),
    );
  }
}

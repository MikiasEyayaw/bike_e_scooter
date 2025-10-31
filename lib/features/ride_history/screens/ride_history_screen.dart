import 'package:flutter/material.dart';
import '../widgets/ride_history_card.dart';

class RideHistoryScreen extends StatelessWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ride History')),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (_, index) => const RideHistoryCard(),
      ),
    );
  }
}

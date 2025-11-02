import 'package:fleet_management/features/trips/presentation/trip_detail_page.dart';
import 'package:flutter/material.dart';

class TripListPage extends StatelessWidget {
  const TripListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final trips = ["Trip A", "Trip B"];
    return Scaffold(
      appBar: AppBar(title: const Text("Trips")),
      body: ListView.builder(
        itemCount: trips.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(trips[index]),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TripDetailPage(tripName: trips[index]),
            ),
          ),
        ),
      ),
    );
  }
}



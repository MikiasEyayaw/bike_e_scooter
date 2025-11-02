import 'package:fleet_management/features/vehicles/presentation/vehicle_detail_page.dart';
import 'package:flutter/material.dart';

class VehicleListPage extends StatelessWidget {
  const VehicleListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final vehicles = ["Bike 001", "Scooter 102", "Bike 003"];
    return Scaffold(
      appBar: AppBar(title: const Text("Vehicles")),
      body: ListView.builder(
        itemCount: vehicles.length,
        itemBuilder: (context, index) => ListTile(
          title: Text(vehicles[index]),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => VehicleDetailPage(vehicleName: vehicles[index]),
            ),
          ),
        ),
      ),
    );
  }
}



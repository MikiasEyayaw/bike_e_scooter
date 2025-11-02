import 'package:flutter/material.dart';

class VehicleDetailPage extends StatelessWidget {
  final String vehicleName;
  const VehicleDetailPage({super.key, required this.vehicleName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(vehicleName)),
      body: Center(child: Text("Details for $vehicleName")),
    );
  }
}
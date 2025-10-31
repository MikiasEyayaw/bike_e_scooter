import 'package:flutter/material.dart';

class VehicleMapWidget extends StatelessWidget {
  const VehicleMapWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      color: Colors.greenAccent.withOpacity(0.3),
      alignment: Alignment.center,
      child: const Text('Map placeholder'),
    );
  }
}

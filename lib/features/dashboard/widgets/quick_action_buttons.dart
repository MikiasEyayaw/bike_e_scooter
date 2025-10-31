import 'package:flutter/material.dart';

class QuickActionButtons extends StatelessWidget {
  const QuickActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.qr_code),
          label: const Text('Scan to Ride'),
        ),
        ElevatedButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.history),
          label: const Text('History'),
        ),
      ],
    );
  }
}

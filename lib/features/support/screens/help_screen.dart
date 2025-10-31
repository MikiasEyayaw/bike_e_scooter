import 'package:flutter/material.dart';
import '../widgets/support_tile.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        children: const [
          SupportTile(title: 'How to start a ride?', content: 'Scan the QR code on the scooter.'),
          SupportTile(title: 'Payment issue?', content: 'Contact support@ridenow.app'),
        ],
      ),
    );
  }
}

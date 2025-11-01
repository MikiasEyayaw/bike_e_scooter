import 'package:flutter/material.dart';
import '../widgets/rewards_card.dart';

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: RewardsCard(),
      ),
    );
  }
}

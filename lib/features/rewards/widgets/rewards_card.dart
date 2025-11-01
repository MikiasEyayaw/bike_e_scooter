import 'package:flutter/material.dart';

class RewardsCard extends StatelessWidget {
  const RewardsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet_outlined),
        title: const Text('Balance'),
        subtitle: const Text('ETB 250.00'),
        trailing: TextButton(onPressed: () {}, child: const Text('Top Up')),
      ),
    );
  }
}

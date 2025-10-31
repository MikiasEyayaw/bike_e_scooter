import 'package:flutter/material.dart';
import '../widgets/wallet_card.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: WalletCard(),
      ),
    );
  }
}

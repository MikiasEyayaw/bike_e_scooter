import 'package:flutter/material.dart';

class SupportTile extends StatelessWidget {
  final String title;
  final String content;

  const SupportTile({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(title),
      children: [Padding(padding: const EdgeInsets.all(8.0), child: Text(content))],
    );
  }
}

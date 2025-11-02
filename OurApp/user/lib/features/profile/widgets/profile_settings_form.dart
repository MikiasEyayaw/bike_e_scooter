import 'package:flutter/material.dart';

class ProfileSettingsForm extends StatelessWidget {
  const ProfileSettingsForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextField(decoration: InputDecoration(labelText: 'Name')),
        const TextField(decoration: InputDecoration(labelText: 'Email')),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: () {}, child: const Text('Update Profile')),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../widgets/profile_settings_form.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: ProfileSettingsForm(),
      ),
    );
  }
}

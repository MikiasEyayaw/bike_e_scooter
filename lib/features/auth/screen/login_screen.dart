import 'package:flutter/material.dart';
import '../../../core/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
          text: "Login",
          onPressed: () {},
        ),
      ),
    );
  }
}

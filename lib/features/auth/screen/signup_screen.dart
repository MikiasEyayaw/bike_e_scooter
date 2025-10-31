import 'package:flutter/material.dart';
import '../../../core/widgets/custom_button.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomButton(
          text: "Sign Up",
          onPressed: () {},
        ),
      ),
    );
  }
}

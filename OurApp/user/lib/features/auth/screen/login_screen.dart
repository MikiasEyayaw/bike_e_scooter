import 'package:bike_e_scooter/features/auth/screen/verification.dart';
import 'package:bike_e_scooter/features/support/screens/help_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( // <-- prevents content under status bar
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              const Text(
                'Welcome to ERide',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 50),

              Image.asset('assets/images/auth/img.png',width: 400,height: 300,),

              const SizedBox(height: 50),

              Center(
                child: CustomButton(
                  text: 'Continue',
                  onPressed: () {
                    Navigator.push(
                      context,MaterialPageRoute(builder: (context)=>const VerificationScreen())
                    );
                  },
                ),
              ),
              const SizedBox(height: 30,),
              Container(

                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,MaterialPageRoute(builder: (context)=>const HelpScreen()),
                    );
                  },
                  child: Text("Learn More"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

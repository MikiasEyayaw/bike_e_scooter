import 'package:flutter/material.dart';

// Auth & Verification
import '../features/auth/screen/login_screen.dart';
import '../features/auth/screen/otp_verfication_screen.dart';
import '../features/auth/screen/signup_screen.dart';
import '../features/auth/screen/verification.dart';

// Main Navigation
import 'main_navigation.dart';

// Route Names
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) 
 {
    switch (settings.name) {

      // --- Splash / Login ---
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      // --- Signup ---
      case RouteNames.signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );

      // --- OTP Verification ---
      case RouteNames.otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phone),
        );

      // --- Dashboard (with Bottom Navigation) ---
      case RouteNames.dashboard:
        return MaterialPageRoute(
          builder: (_) => const MainNavigation(),
        );

      // --- Verification Screen ---
      case RouteNames.verification:
        return MaterialPageRoute(
          builder: (_) => const VerificationScreen(),
        );

      // --- Default / Unknown Route ---
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}

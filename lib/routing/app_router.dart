import 'package:flutter/material.dart';
import '../features/auth/screen/login_screen.dart';
import '../features/auth/screen/otp_verfication_screen.dart';
import '../features/auth/screen/signup_screen.dart';
import '../features/dashboard/screens/dashboard_screen.dart';
import '../features/ride_history/screens/ride_history_screen.dart';
import '../features/wallet/screens/wallet_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/support/screens/help_screen.dart';
import '../features/auth/screen/verification.dart'; // ✅ added import
import 'route_names.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.splash:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case RouteNames.login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
        );

      case RouteNames.signup:
        return MaterialPageRoute(
          builder: (_) => const SignupScreen(),
        );

      case RouteNames.otpVerification:
        final args = settings.arguments as Map<String, dynamic>?;
        final phone = args?['phone'] ?? '';
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(phoneNumber: phone),
        );

      case RouteNames.dashboard:
        return MaterialPageRoute(
          builder: (_) => const DashboardScreen(),
        );

      case RouteNames.rideHistory:
        return MaterialPageRoute(
          builder: (_) => const RideHistoryScreen(),
        );

      case RouteNames.wallet:
        return MaterialPageRoute(
          builder: (_) => const WalletScreen(),
        );

      case RouteNames.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
        );

      case RouteNames.support:
        return MaterialPageRoute(
          builder: (_) => const HelpScreen(),
        );

      // ✅ new route added here
      case RouteNames.verification:
        return MaterialPageRoute(
          builder: (_) => const VerificationScreen(),
        );

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
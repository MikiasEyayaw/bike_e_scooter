import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'routes/route_names.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const FleetApp());
}

class FleetApp extends StatelessWidget {
  const FleetApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fleet Management',
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.dashboard,
      onGenerateRoute: AppRoutes.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}

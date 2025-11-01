import 'package:flutter/material.dart';
import 'routing/app_router.dart';
import 'routing/route_names.dart';
import 'core/themes/app_theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RideNow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: RouteNames.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }
}

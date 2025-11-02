import 'package:flutter/material.dart';

// === Auth Pages ===
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/register_page.dart';
import '../features/auth/presentation/forgot_password_page.dart';

// === Dashboard ===
import '../features/dashboard/presentation/dashboard_page.dart';

// === Vehicles ===
import '../features/vehicles/presentation/vehicle_list_page.dart';
import '../features/vehicles/presentation/add_vehicle_page.dart';

// === Trips ===
import '../features/trips/presentation/trip_list_page.dart';

// === Maintenance ===
import '../features/maintenance/presentation/maintenance_list_page.dart';

// === Reports ===
import '../features/reports/presentation/reports_page.dart';

import 'route_names.dart';

class AppRoutes {
  // Map of route names to page builders
  static final Map<String, Widget Function(BuildContext)> _routes = {
    // 🔐 Auth
    RouteNames.login: (_) => const LoginPage(),
    RouteNames.register: (_) => const RegisterPage(),
    RouteNames.forgotPassword: (_) => const ForgotPasswordPage(),

    // 🏠 Dashboard
    RouteNames.dashboard: (_) => const DashboardPage(),

    // 🚗 Vehicles
    RouteNames.vehicles: (_) => const VehicleListPage(),
    RouteNames.addVehicle: (_) => const AddVehiclePage(),

    // 🧭 Trips
    RouteNames.trips: (_) => const TripListPage(),

    // 🔧 Maintenance
    RouteNames.maintenance: (_) => const MaintenanceListPage(),

    // 📊 Reports
    RouteNames.reports: (_) => const ReportsPage(),
    
  };

  // Route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final pageBuilder = _routes[settings.name];
    if (pageBuilder != null) {
      return MaterialPageRoute(builder: pageBuilder, settings: settings);
    }

    // ❌ Default route for unknown paths
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route not found')),
      ),
    );
  }
}

import 'package:fleet_management/routes/route_names.dart';

class RouteGuard {
  static bool isLoggedIn = false; // dummy auth flag

  static bool canAccess(String routeName) {
    // Example: only allow dashboard, vehicles, trips, maintenance, reports if logged in
    const protectedRoutes = [
      RouteNames.dashboard,
      RouteNames.vehicles,
      RouteNames.vehicleDetail,
      RouteNames.addVehicle,
      RouteNames.trips,
      RouteNames.tripDetail,
      RouteNames.maintenance,
      RouteNames.maintenanceDetail,
      RouteNames.reports,
      RouteNames.reportDetail,
    ];

    if (protectedRoutes.contains(routeName) && !isLoggedIn) {
      return false;
    }
    return true;
  }
}

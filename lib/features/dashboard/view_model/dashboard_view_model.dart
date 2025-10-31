class DashboardViewModel {
  String greeting = 'Welcome to RideNow!';
  int availableVehicles = 5;

  void refreshData() {
    availableVehicles++;
  }
}

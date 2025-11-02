class VehicleBloc {
  List<String> availableVehicles = ['Bike #1', 'Scooter #2'];

  void refreshVehicles() {
    availableVehicles.add('Bike #${availableVehicles.length + 1}');
  }
}

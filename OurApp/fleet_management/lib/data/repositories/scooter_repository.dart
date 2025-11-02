import '../models/scooter_model.dart';

class ScooterRepository {
  Future<List<Scooter>> getAllScooters() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Scooter(id: '1', name: 'Scooter 101', batteryLevel: 78.5),
      Scooter(id: '2', name: 'Scooter 102', batteryLevel: 54.2),
    ];
  }
}

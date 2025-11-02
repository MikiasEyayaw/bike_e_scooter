import '../models/bike_model.dart';

class BikeRepository {
  Future<List<Bike>> getAllBikes() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Bike(id: '1', name: 'Bike 001', status: 'available'),
      Bike(id: '2', name: 'Bike 002', status: 'maintenance'),
    ];
  }
}

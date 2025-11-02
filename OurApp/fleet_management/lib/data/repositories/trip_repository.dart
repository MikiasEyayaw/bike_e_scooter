import '../models/trip_model.dart';

class TripRepository {
  Future<List<Trip>> getTrips() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Trip(id: 't1', vehicleId: 'v1', startTime: DateTime.now()),
    ];
  }
}

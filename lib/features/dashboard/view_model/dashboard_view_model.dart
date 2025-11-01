import 'dart:async';
import 'dart:math';

enum VehicleType { scooter, bike }

class Vehicle {
  final String id;
  final String name;
  final VehicleType type;
  int battery; // mutable for demo %
  final double pricePerMin;
  final double distanceKm;
  final double lat;
  final double lng;
  final String imageUrl;
  final double maxRangeKm;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.battery,
    required this.pricePerMin,
    required this.distanceKm,
    required this.lat,
    required this.lng,
    required this.imageUrl,
    required this.maxRangeKm,
  });
}

class DashboardViewModel {
  /// Greeting and summary data
  String greeting = 'Welcome to RideNow!';
  int availableVehicles = 5;

  /// Filters
  bool filterScooters = true;
  bool filterBikes = true;
  int minBattery = 20;
  int maxDistance = 10; // km

  /// Demo text fields (search & message)
  String searchDestination = '';
  String messageToSupport = '';

  /// Active ride tracking
  Vehicle? activeRide;
  DateTime? rideStartTime;
  DateTime? rideUnlockTime;
  double userLat = 37.7749; // initial fake user position
  double userLng = -122.4194;
  List<List<double>> routePositions = [];

  /// Internal simulation timers
  Timer? _movementTimer;
  final Random _rand = Random();

  /// Vehicles sample
  final List<Vehicle> vehicles = [
    Vehicle(
      id: 'V1',
      name: 'E-Bike #4567',
      type: VehicleType.bike,
      battery: 85,
      pricePerMin: 5,
      distanceKm: 0.2,
      lat: 37.7749,
      lng: -122.4194,
      imageUrl:
          'https://razor.com/wp-content/uploads/2018/01/A_RD_Product.jpeg',
      maxRangeKm: 25,
    ),
    Vehicle(
      id: 'V2',
      name: 'Scooter #772',
      type: VehicleType.scooter,
      battery: 63,
      pricePerMin: 3,
      distanceKm: 0.6,
      lat: 37.7765,
      lng: -122.4170,
      imageUrl:
          'https://razor.com/wp-content/uploads/2018/01/A_RD_Product.jpeg',
      maxRangeKm: 20,
    ),
    Vehicle(
      id: 'V3',
      name: 'Scooter #123',
      type: VehicleType.scooter,
      battery: 45,
      pricePerMin: 3,
      distanceKm: 1.2,
      lat: 37.7723,
      lng: -122.4216,
      imageUrl:
          'https://cdn.pixabay.com/photo/2019/11/13/11/48/electric-scooter-4624163_1280.jpg',
      maxRangeKm: 18,
    ),
    Vehicle(
      id: 'V4',
      name: 'E-Bike #999',
      type: VehicleType.bike,
      battery: 92,
      pricePerMin: 6,
      distanceKm: 0.8,
      lat: 37.7705,
      lng: -122.4231,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/11/29/10/07/bicycle-1867046_1280.jpg',
      maxRangeKm: 30,
    ),
    Vehicle(
      id: 'V5',
      name: 'Scooter #234',
      type: VehicleType.scooter,
      battery: 30,
      pricePerMin: 2.5,
      distanceKm: 2.0,
      lat: 37.7790,
      lng: -122.4180,
      imageUrl:
          'https://cdn.pixabay.com/photo/2020/02/12/10/50/scooter-4843386_1280.jpg',
      maxRangeKm: 12,
    ),
  ];

  // ----------------------------- CORE LOGIC ----------------------------------

  void refreshData() {
    availableVehicles = vehicles.length;
  }

  /// Called after QR scan is successful → unlock the vehicle
  void startRide(Vehicle v) {
    activeRide = v;
    rideStartTime = DateTime.now();
    rideUnlockTime = DateTime.now();
    routePositions = [
      [userLat, userLng]
    ];
    _startSimulatedMovement();
  }

  /// End active ride
  void endRide() {
    _movementTimer?.cancel();
    _movementTimer = null;
    activeRide = null;
    rideStartTime = null;
    rideUnlockTime = null;
    routePositions.clear();
  }

  bool get hasActiveRide => activeRide != null;

  /// ---------------------- SIMULATION & DEMO METHODS -------------------------

  /// Simulate user movement every few seconds (randomly)
  void _startSimulatedMovement() {
    _movementTimer?.cancel();
    _movementTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      // randomly move within small bounds
      userLat += (_rand.nextDouble() - 0.5) * 0.0005;
      userLng += (_rand.nextDouble() - 0.5) * 0.0005;
      routePositions.add([userLat, userLng]);

      // simulate battery drain and ride progress
      if (activeRide != null) {
        if (activeRide!.battery > 0) {
          activeRide!.battery -= _rand.nextInt(2); // drain 0–1%
        } else {
          endRide();
        }
      }
    });
  }

  /// Demo sending a message to support
  void sendMessage(String msg) {
    messageToSupport = msg;
    print('📨 Message sent to support: $msg');
  }

  /// Demo destination search
  List<String> searchPlaces(String query) {
    searchDestination = query;
    final mockResults = [
      'Central Park',
      'Downtown Plaza',
      'City Mall',
      'University Avenue',
      'Airport Terminal',
      'Main Station',
    ];
    return mockResults
        .where((place) => place.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Dispose timers when leaving dashboard
  void dispose() {
    _movementTimer?.cancel();
  }
}

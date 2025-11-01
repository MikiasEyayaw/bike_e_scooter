// screens/active_ride_screen.dart
import 'dart:async';
import 'dart:math' as math;
import 'ride_summary_screen.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../view_model/dashboard_view_model.dart';

class ActiveRideScreen extends StatefulWidget {
  /// If you pass `viewModel`, the screen will show the live ride.
  /// If you use the `.current()` constructor, it will show the "no active rides" UI.
  final DashboardViewModel? viewModel;
  final VoidCallback? onEnd;

  const ActiveRideScreen({super.key, required this.viewModel, this.onEnd});

  const ActiveRideScreen.current({super.key})
      : viewModel = null,
        onEnd = null;

  @override
  State<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends State<ActiveRideScreen> {
  GoogleMapController? _mapController;
  Timer? _refreshTimer; // refresh UI frequently for smoothness (300ms)
  Timer? _aiTipTimer; // update AI tip every minute
  String _aiTip = 'Stay safe — obey traffic rules.';
  Duration _rideDuration = Duration.zero;
  double _rideDistanceKm = 0.0;
  double _rideCost = 0.0;

  @override
  void initState() {
    super.initState();
    if (hasRide) {
      _startRefreshLoop();
      _startAiTipLoop();
    }
  }

  bool get hasRide => widget.viewModel != null && widget.viewModel!.hasActiveRide;

  @override
  void didUpdateWidget(covariant ActiveRideScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // restart timers if a ride appears
    if (hasRide && _refreshTimer == null) {
      _startRefreshLoop();
      _startAiTipLoop();
    }
    if (!hasRide) {
      _cancelTimers();
    }
  }

  void _startRefreshLoop() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      _recalculateMetrics();
      // animate camera to user location for smoothness
      final vm = widget.viewModel;
      if (vm != null && _mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(vm.userLat, vm.userLng),
          ),
        );
      }
      if (mounted) setState(() {});
    });
  }

  void _startAiTipLoop() {
    _aiTipTimer?.cancel();
    _updateAiTip(); // immediate
    _aiTipTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      _updateAiTip();
    });
  }

  void _cancelTimers() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
    _aiTipTimer?.cancel();
    _aiTipTimer = null;
  }

  void _updateAiTip() {
    final vm = widget.viewModel;
    if (vm == null || vm.activeRide == null) {
      _aiTip = 'No active ride.';
      return;
    }

    // reactive tips + randomization
    final battery = vm.activeRide!.battery;
    final distancePoints = vm.routePositions.length;

    if (battery < 20) {
      _aiTip = 'Battery low — consider swapping bikes or ending ride soon.';
    } else if (distancePoints > 30) {
      _aiTip = 'Long route ahead — keep an eye on battery and speed.';
    } else {
      // small random selection
      final tips = [
        'Low traffic ahead — keep left to reach your destination faster.',
        'Maintain steady speed for better battery life.',
        'Avoid steep hills to conserve battery.',
        'Stay in bike lanes where available.',
      ];
      final r = math.Random().nextInt(tips.length);
      _aiTip = tips[r];
    }
    if (mounted) setState(() {});
  }

  void _recalculateMetrics() {
    final vm = widget.viewModel;
    if (vm == null || vm.rideStartTime == null || vm.activeRide == null) {
      _rideDuration = Duration.zero;
      _rideDistanceKm = 0.0;
      _rideCost = 0.0;
      return;
    }

    _rideDuration = DateTime.now().difference(vm.rideStartTime!);
    _rideDistanceKm = _calcDistanceKm(vm.routePositions);
    final minutes = _rideDuration.inSeconds / 60.0;
    _rideCost = minutes * (vm.activeRide?.pricePerMin ?? 0.0);
  }

  double _calcDistanceKm(List<List<double>> positions) {
    if (positions.length < 2) return 0.0;
    double total = 0.0;
    for (int i = 0; i < positions.length - 1; i++) {
      final a = positions[i];
      final b = positions[i + 1];
      total += _haversine(a[0], a[1], b[0], b[1]);
    }
    return total;
  }

  // haversine returns distance in kilometers
  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const R = 6371.0; // km
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_deg2rad(lat1)) *
            math.cos(_deg2rad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  double _deg2rad(double deg) => deg * (math.pi / 180.0);

  @override
  void dispose() {
    _cancelTimers();
    _mapController?.dispose();
    super.dispose();
  }

void _endRide() {
  widget.viewModel?.endRide();
  widget.onEnd?.call();

  // Navigate to Ride Summary instead of showing a snackbar
  Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => const RideSummaryScreen()),
  );
}


  Widget _controlButton(IconData icon, VoidCallback onTap,
      {Color background = Colors.white, Color iconColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: GestureDetector(
        onTap: onTap,
        child: CircleAvatar(
          radius: 22,
          backgroundColor: background,
          child: Icon(icon, color: iconColor),
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = two(d.inHours);
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (!hasRide) {
      // show the "current rides" fallback UI
      return Scaffold(
        appBar: AppBar(title: const Text('My Active Rides')),
        body: const Center(child: Text('You have no active rides right now.')),
      );
    }

    final vm = widget.viewModel!;
    final vehicle = vm.activeRide!;

    // build polylines: historic route (yellow) and recent live segment (green)
    final List<LatLng> allPoints = vm.routePositions.map((p) => LatLng(p[0], p[1])).toList();
    final Set<Polyline> polylines = {};

    if (allPoints.length >= 2) {
      polylines.add(Polyline(
        polylineId: const PolylineId('historic'),
        points: allPoints,
        color: Colors.yellow.shade700,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ));

      // green live poly for last few points
      final int liveCount = math.min(4, allPoints.length);
      final recent = allPoints.sublist(allPoints.length - liveCount);
      polylines.add(Polyline(
        polylineId: const PolylineId('live'),
        points: recent,
        color: Colors.green,
        width: 6,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
      ));
    }

    // white faint background path (to mimic screenshot faint path)
    if (allPoints.length >= 2) {
      polylines.add(Polyline(
        polylineId: const PolylineId('bg'),
        points: allPoints,
        color: Colors.white70,
        width: 2,
      ));
    }

    final initialCamera = CameraPosition(target: LatLng(vm.userLat, vm.userLng), zoom: 15.0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map
          GoogleMap(
            initialCameraPosition: initialCamera,
            polylines: polylines,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (c) => _mapController = c,
            markers: {
              Marker(
                markerId: const MarkerId('vehicle_marker'),
                position: LatLng(vehicle.lat, vehicle.lng),
                infoWindow: InfoWindow(title: vehicle.name),
              ),
              Marker(
                markerId: const MarkerId('user_marker'),
                position: LatLng(vm.userLat, vm.userLng),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
              ),
            },
          ),

          // top green bar
          Positioned(
            top: 40,
            left: 12,
            right: 12,
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(children: [
                    const Icon(Icons.timer, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(_formatDuration(_rideDuration),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                  Row(children: [
                    const Icon(Icons.directions_bike, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text('${_rideDistanceKm.toStringAsFixed(1)} km',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                  Row(children: [
                    const Icon(Icons.battery_charging_full, color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text('${vehicle.battery}%',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                ],
              ),
            ),
          ),

          // right side control column
          Positioned(
            right: 12,
            top: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              children: [
                _controlButton(Icons.pause, () {
                  // placeholder: pause/resume (not implemented in simulation)
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pause/Resume (demo)')));
                }),
                _controlButton(Icons.error_outline, () {
                  // show an alert / report modal
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Report issue'),
                      content: const Text('This is a demo report dialog.'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                      ],
                    ),
                  );
                }),
                _controlButton(Icons.navigation, () {
                  // navigation placeholder
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Open Navigation (demo)')));
                }),
                _controlButton(Icons.stop_circle, () {
                  // end ride (red)
                  _showConfirmEnd();
                }, background: Colors.red, iconColor: Colors.white),
              ],
            ),
          ),

          // bottom card with cost and AI tip + End Ride button
          Positioned(
            left: 12,
            right: 12,
            bottom: 20,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 6))],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Live Ride Cost', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_rideCost.toStringAsFixed(2)} Birr',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      // AI tip pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lightbulb, size: 16, color: Colors.green),
                            const SizedBox(width: 6),
                            const Text('AI Tip', style: TextStyle(fontSize: 12, color: Colors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(_aiTip, style: const TextStyle(fontSize: 13, color: Colors.black87)),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _showConfirmEnd,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('End Ride', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfirmEnd() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('End ride'),
        content: const Text('Are you sure you want to end the ride?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _endRide();
            },
            child: const Text('End', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

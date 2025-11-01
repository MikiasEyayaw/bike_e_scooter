// screens/dashboard_screen.dart
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../view_model/dashboard_view_model.dart';
import '../view_model/vehicle_modal.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/quick_action_buttons.dart';
import '../widgets/vehicle_map_widget.dart';
import 'active_ride_screen.dart';
import 'scan_qr_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final DashboardViewModel vm = DashboardViewModel();
  GoogleMapController? _mapController;
  Timer? _trackingTimer;
  String _searchText = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _trackingTimer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _startTracking(Vehicle vehicle) {
    // ensure previous timer is cancelled
    _trackingTimer?.cancel();

    // mark active ride in vm
    setState(() {
      vm.startRide(vehicle);
    });

    // small UX toast
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${vehicle.name} unlocked — ride started')),
    );

    // simulate movement: move user location slightly toward vehicle for demo,
    // then random walk. Also drain battery slowly.
    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (t) {
      setState(() {
        // small random movement
        final rnd = Random();
        final dx = (rnd.nextDouble() - 0.5) * 0.0004;
        final dy = (rnd.nextDouble() - 0.5) * 0.0004;
        vm.userLat += dx;
        vm.userLng += dy;
        vm.routePositions.add([vm.userLat, vm.userLng]);

        // drain battery of active vehicle slowly for demo
        if (vm.activeRide != null) {
          vm.activeRide!.battery = max(0, vm.activeRide!.battery - 1);
        }
      });

      // animate camera to new user location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(LatLng(vm.userLat, vm.userLng)),
        );
      }
    });
  }

  void _stopTrackingAndEndRide() {
    _trackingTimer?.cancel();
    setState(() {
      vm.endRide();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ride ended')));
  }

  void _onMarkerTapped(Vehicle vehicle) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => VehicleModal(
        vehicle: vehicle,
        onReserve: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Vehicle reserved successfully.')));
        },
        onScan: () async {
          // open scan screen and wait for result
          final result = await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => ScanQrScreen(vehicle: vehicle)),
          );

          // if a simulated QR payload came back -> start ride
          if (result != null && result.toString().startsWith('QR_OK')) {
            Navigator.of(context).pop(); // close modal
            _startTracking(vehicle);

            // navigate to active ride screen and provide end callback
            Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => ActiveRideScreen(
      viewModel: vm,
      onEnd: _stopTrackingAndEndRide,
    ),
  ),
);
          } else {
            // cancelled or failed
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scan cancelled or failed')));
          }
        },
      ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _goToMyLocation() async {
    if (_mapController == null) return;
    await _mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(vm.userLat, vm.userLng), 15),
    );
  }

  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setLocalState) => Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Filters', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: vm.filterScooters,
              onChanged: (v) => setLocalState(() => setState(() => vm.filterScooters = v ?? false)),
              title: const Text('Show scooters'),
            ),
            CheckboxListTile(
              value: vm.filterBikes,
              onChanged: (v) => setLocalState(() => setState(() => vm.filterBikes = v ?? false)),
              title: const Text('Show bikes'),
            ),
            ListTile(
              title: const Text('Min battery (%)'),
              subtitle: Slider(
                min: 0,
                max: 100,
                divisions: 20,
                value: vm.minBattery.toDouble(),
                label: '${vm.minBattery}%',
                onChanged: (val) => setLocalState(() => setState(() => vm.minBattery = val.toInt())),
              ),
            ),
            ListTile(
              title: const Text('Max distance (km)'),
              subtitle: Slider(
                min: 0,
                max: 50,
                divisions: 50,
                value: vm.maxDistance.toDouble(),
                label: '${vm.maxDistance} km',
                onChanged: (val) => setLocalState(() => setState(() => vm.maxDistance = val.toInt())),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        vm.filterBikes = true;
                        vm.filterScooters = true;
                        vm.minBattery = 20;
                        vm.maxDistance = 10;
                      });
                      Navigator.of(context).pop();
                    },
                    child: const Text('Reset'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Apply'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  void _openMessageModal() {
    final TextEditingController msgController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('Report / Message', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          TextField(
            controller: msgController,
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe the issue or message...',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    final text = msgController.text.trim();
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Message sent: ${text.isEmpty ? '(empty)' : text}')));
                  },
                  child: const Text('Send'),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // apply search and filters to marker list
    final visibleVehicles = vm.vehicles.where((v) {
      if (!vm.filterScooters && v.type == VehicleType.scooter) return false;
      if (!vm.filterBikes && v.type == VehicleType.bike) return false;
      if (v.battery < vm.minBattery) return false;
      if (v.distanceKm > vm.maxDistance) return false;
      if (_searchText.isNotEmpty && !v.name.toLowerCase().contains(_searchText.toLowerCase())) return false;
      return true;
    }).toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Top header: search + filter + "View my current rides" button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) => setState(() => _searchText = val),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search destination or nearby',
                        contentPadding: const EdgeInsets.symmetric(vertical: 0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _openFilterDialog,
                    icon: const Icon(Icons.filter_list),
                  ),
                  const SizedBox(width: 8),
               if (vm.hasActiveRide)
  ElevatedButton(
    onPressed: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ActiveRideScreen(
            viewModel: vm,
            onEnd: _stopTrackingAndEndRide,
          ),
        ),
      );
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      side: const BorderSide(color: Colors.grey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    child: const Text('View My Current Ride'),
  ),

                ],
              ),
            ),

            const DashboardHeader(),
            const SizedBox(height: 8),
            const QuickActionButtons(),
            const SizedBox(height: 8),

            // Map expands
            Expanded(
              child: Stack(
                children: [
                  VehicleMapWidget(
                    vehicles: visibleVehicles,
                    onMapCreated: _onMapCreated,
                    onMarkerTap: _onMarkerTapped,
                    userLocation: LatLng(vm.userLat, vm.userLng),
                    route: vm.routePositions.map((p) => LatLng(p[0], p[1])).toList(),
                  ),

                  // floating home location button (bottom-right)
                  Positioned(
                    right: 12,
                    bottom: 80,
                    child: FloatingActionButton(
                      heroTag: 'home_loc',
                      onPressed: _goToMyLocation,
                      child: const Icon(Icons.my_location),
                    ),
                  ),

                  // message/report button (above home_loc)
                  Positioned(
                    right: 12,
                    bottom: 140,
                    child: FloatingActionButton(
                      heroTag: 'report',
                      onPressed: _openMessageModal,
                      child: const Icon(Icons.message),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // Floating action to end ride if active
      floatingActionButton: vm.hasActiveRide
          ? FloatingActionButton.extended(
              onPressed: _stopTrackingAndEndRide,
              label: const Text('End Ride'),
              icon: const Icon(Icons.stop_circle),
              backgroundColor: Colors.redAccent,
            )
          : null,
    );
  }
}

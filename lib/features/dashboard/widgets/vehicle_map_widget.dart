// lib/features/dashboard/widgets/vehicle_map_widget.dart
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../view_model/dashboard_view_model.dart';

class VehicleMapWidget extends StatefulWidget {
  final List<Vehicle> vehicles;
  final void Function(GoogleMapController) onMapCreated;
  final void Function(Vehicle) onMarkerTap;
  final LatLng? userLocation;
  final List<LatLng>? route;

  const VehicleMapWidget({
    super.key,
    required this.vehicles,
    required this.onMapCreated,
    required this.onMarkerTap,
    this.userLocation,
    this.route,
  });

  @override
  State<VehicleMapWidget> createState() => _VehicleMapWidgetState();
}

class _VehicleMapWidgetState extends State<VehicleMapWidget> {
  final Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _initMarkers();
    _buildPolyline();
  }

  @override
  void didUpdateWidget(covariant VehicleMapWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initMarkers();
    _buildPolyline();
  }

  Future<void> _initMarkers() async {
    final Set<Marker> m = {};

    for (var v in widget.vehicles) {
      final icon = await _getCustomMarkerIcon(
        v.type == VehicleType.bike ? Icons.pedal_bike : Icons.electric_scooter,
        v.type == VehicleType.bike ? Colors.green : Colors.blueAccent,
      );

      m.add(
        Marker(
          markerId: MarkerId(v.id),
          position: LatLng(v.lat, v.lng),
          infoWindow: InfoWindow(title: v.name, snippet: '${v.battery}% battery'),
          icon: icon,
          onTap: () => widget.onMarkerTap(v),
        ),
      );
    }

    // optional: add user position marker
    if (widget.userLocation != null) {
      final userIcon = await _getCustomMarkerIcon(Icons.person_pin_circle, Colors.redAccent);
      m.add(Marker(
        markerId: const MarkerId('user_pos'),
        position: widget.userLocation!,
        infoWindow: const InfoWindow(title: 'You'),
        icon: userIcon,
      ));
    }

    setState(() => _markers = m);
  }

  Future<BitmapDescriptor> _getCustomMarkerIcon(IconData icon, Color color) async {
    const double size = 50.0;
    final ui.PictureRecorder recorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final Paint paint = Paint()..color = color;
    final Offset center = const Offset(size / 2, size / 2);

    // background circle
    canvas.drawCircle(center, size / 2.4, paint);

    // draw icon
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(icon.codePoint),
      style: TextStyle(
        fontSize: size / 2,
        fontFamily: icon.fontFamily,
        color: Colors.white,
        package: icon.fontPackage,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2, center.dy - textPainter.height / 2),
    );

    final ui.Image img = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final ByteData? data = await img.toByteData(format: ui.ImageByteFormat.png);
    return BitmapDescriptor.fromBytes(data!.buffer.asUint8List());
  }

  void _buildPolyline() {
    if (widget.route != null && widget.route!.length >= 2) {
      _polylines = {
        Polyline(
          polylineId: const PolylineId('route'),
          points: widget.route!,
          width: 4,
          color: Colors.blueAccent,
        ),
      };
    } else {
      _polylines = {};
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final initialLatLng = widget.vehicles.isNotEmpty
        ? LatLng(widget.vehicles[0].lat, widget.vehicles[0].lng)
        : const LatLng(37.7749, -122.4194);

    return GoogleMap(
      initialCameraPosition: CameraPosition(target: initialLatLng, zoom: 14),
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      markers: _markers,
      polylines: _polylines,
      onMapCreated: (controller) {
        if (!_controller.isCompleted) _controller.complete(controller);
        widget.onMapCreated(controller);
      },
    );
  }
}

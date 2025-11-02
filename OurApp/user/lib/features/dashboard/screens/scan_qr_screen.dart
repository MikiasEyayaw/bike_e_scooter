// screens/scan_qr_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import '../view_model/dashboard_view_model.dart';

class ScanQrScreen extends StatefulWidget {
  final Vehicle vehicle;

  const ScanQrScreen({super.key, required this.vehicle});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _scanning = false;
  String? _result;

  void _simulateScan() async {
    setState(() {
      _scanning = true;
      _result = null;
    });
    // simulate camera + scan delay
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _scanning = false;
      _result = 'QR_OK:${widget.vehicle.id}'; // fake payload
    });

    // give a short delay for UX then pop with success
    await Future.delayed(const Duration(milliseconds: 500));
    Navigator.of(context).pop(_result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // fake camera preview box
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: _scanning
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            CircularProgressIndicator(),
                            SizedBox(height: 12),
                            Text('Scanning...'),
                          ],
                        )
                      : _result != null
                          ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.check_circle, size: 56, color: Colors.green),
                                const SizedBox(height: 8),
                                Text('Scanned: $_result'),
                              ],
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.qr_code, size: 56),
                                SizedBox(height: 8),
                                Text('Point camera at the QR code'),
                              ],
                            ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _scanning ? null : _simulateScan,
              icon: const Icon(Icons.qr_code_scanner),
              label: const Text('Simulate Scan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(48),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

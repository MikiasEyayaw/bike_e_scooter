import 'package:flutter/material.dart';

void showRideDetailModal(BuildContext context, Map<String, String> ride) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ride Details",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Text("Date: ${ride["date"]}"),
            Text("Distance: ${ride["distance"]}"),
            Text("Fare: ${ride["fare"]}"),
            Text("Status: ${ride["status"]}"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Center(child: Text("Close")),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size.fromHeight(40),
              ),
            ),
          ],
        ),
      );
    },
  );
}

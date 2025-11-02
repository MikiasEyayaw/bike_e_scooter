import 'package:flutter/material.dart';

class TripDetailPage extends StatelessWidget {
  final String tripName;
  const TripDetailPage({super.key, required this.tripName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tripName)),
      body: Center(child: Text("Details for $tripName")),
    );
  }
}

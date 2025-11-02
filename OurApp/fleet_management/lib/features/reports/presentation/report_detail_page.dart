import 'package:flutter/material.dart';
class ReportDetailPage extends StatelessWidget {
  final String reportName;
  const ReportDetailPage({super.key, required this.reportName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(reportName)),
      body: Center(child: Text("Details for $reportName")),
    );
  }
}
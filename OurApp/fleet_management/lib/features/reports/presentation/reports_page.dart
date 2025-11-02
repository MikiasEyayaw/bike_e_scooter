import 'package:fleet_management/features/reports/presentation/report_detail_page.dart';
import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = ["Monthly Usage", "Incident Report"];
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (_, index) => ListTile(
          title: Text(reports[index]),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ReportDetailPage(reportName: reports[index]),
            ),
          ),
        ),
      ),
    );
  }
}


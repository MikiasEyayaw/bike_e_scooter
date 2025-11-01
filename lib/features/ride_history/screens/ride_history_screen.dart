import 'package:flutter/material.dart';

void main() {
  runApp(RideApp());
}

class RideApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RideHistoryScreen(),
    );
  }
}

class RideHistoryScreen extends StatefulWidget {
  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  String selectedFilter = "All";

  List<Map<String, String>> rides = [
    {
      "date": "2024-07-28 14:30",
      "distance": "5.2 km",
      "fare": "150 ETB",
      "status": "Completed",
    },
    {
      "date": "2024-07-27 09:15",
      "distance": "2.8 km",
      "fare": "80 ETB",
      "status": "Completed",
    },
    {
      "date": "2024-07-26 18:00",
      "distance": "7.5 km",
      "fare": "200 ETB",
      "status": "Completed",
    },
    {
      "date": "2024-07-25 12:45",
      "distance": "0.0 km",
      "fare": "0 ETB",
      "status": "Cancelled",
    },
    {
      "date": "2024-07-24 07:00",
      "distance": "1.5 km",
      "fare": "50 ETB",
      "status": "Completed",
    },
    {
      "date": "2024-07-23 16:20",
      "distance": "3.1 km",
      "fare": "90 ETB",
      "status": "Ongoing",
    },
  ];

  int? selectedIndex;

  void _exportPDF() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DownloadScreen()),
    );
  }

  void _deleteSelectedRide() async {
    if (selectedIndex == null) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Ride"),
        content: const Text("Are you sure you want to delete this ride?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() {
        rides.removeAt(selectedIndex!);
        selectedIndex = null; // Clear selection after deletion
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Ride deleted successfully")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredRides = selectedFilter == "All"
        ? rides
        : rides.where((ride) => ride["status"] == selectedFilter).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Colors.black),
        title: const Text(
          'Ride History',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                FilterButton(
                  label: 'All',
                  isSelected: selectedFilter == 'All',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'All';
                      selectedIndex = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterButton(
                  label: 'Completed',
                  isSelected: selectedFilter == 'Completed',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Completed';
                      selectedIndex = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterButton(
                  label: 'Ongoing',
                  isSelected: selectedFilter == 'Ongoing',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Ongoing';
                      selectedIndex = null;
                    });
                  },
                ),
                const SizedBox(width: 8),
                FilterButton(
                  label: 'Cancelled',
                  isSelected: selectedFilter == 'Cancelled',
                  onTap: () {
                    setState(() {
                      selectedFilter = 'Cancelled';
                      selectedIndex = null;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _exportPDF,
                    icon: const Icon(
                      Icons.picture_as_pdf_outlined,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Export PDF',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: BorderSide(color: Colors.grey.shade400),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: selectedIndex == null
                        ? null
                        : _deleteSelectedRide,
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    label: const Text('Delete History'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedIndex == null
                          ? Colors.grey
                          : const Color.fromARGB(255, 143, 59, 53),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredRides.isEmpty
                  ? const Center(child: Text("No rides found"))
                  : ListView.builder(
                      itemCount: filteredRides.length,
                      itemBuilder: (context, index) {
                        final ride = filteredRides[index];
                        final realIndex = rides.indexOf(ride);
                        bool isSelected = selectedIndex == realIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if (selectedIndex == realIndex) {
                                selectedIndex = null;
                              } else {
                                selectedIndex = realIndex;
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? Colors.green
                                    : Colors.grey.shade300,
                                width: isSelected ? 2 : 1,
                              ),
                              color: isSelected
                                  ? Colors.green.withOpacity(0.1)
                                  : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ride["date"]!,
                                      style: const TextStyle(
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          ride["distance"]!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text("  ·  "),
                                        Text(
                                          ride["fare"]!,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(
                                      ride["status"]!,
                                    ).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    ride["status"]!,
                                    style: TextStyle(
                                      color: _getStatusColor(ride["status"]!),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Ongoing':
        return Colors.blue;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.green : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class DownloadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Download PDF"),
        backgroundColor: Colors.green,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.picture_as_pdf_outlined, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Downloading your ride history PDF...",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(color: Colors.green),
          ],
        ),
      ),
    );
  }
}

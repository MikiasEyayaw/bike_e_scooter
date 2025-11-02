import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardTab(),
    Center(child: Text('Tasks Page')),
    Center(child: Text('Fleet Page')),
    Center(child: Text('Analytics Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: SafeArea(
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
            BottomNavigationBarItem(icon: Icon(Icons.directions_car), label: 'Fleet'),
            BottomNavigationBarItem(icon: Icon(Icons.analytics), label: 'Analytics'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// -------------------- Dashboard Tab -------------------- //

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  final CameraPosition _initialPosition =
  const CameraPosition(target: LatLng(11.5842, 37.3714), zoom: 12);

  String? _selectedFilter;

  // Show filter-specific dialogs
  Future<void> _onFilterSelected(String label) async {
    setState(() => _selectedFilter = label);

    String? result;

    switch (label) {
      case "Vehicle Type":
        result = await _showOptionsDialog(label, ["Bike", "Scooter"]);
        break;
      case "Battery %":
        result = await _showOptionsDialog(label, ["0-20%", "20-50%", "50-100%"]);
        break;
      case "Zone":
        result = await _showOptionsDialog(label, ["Depo", "Poly", "Peda", "Paperes"]);
        break;
      case "Status":
        result = await _showOptionsDialog(label, ["Active", "Inactive", "Maintenance"]);
        break;
    }

    if (result != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$label filter selected: $result')),
      );
    }

    // Reset selection highlight after selection
    setState(() => _selectedFilter = null);
  }

  Future<String?> _showOptionsDialog(String title, List<String> options) {
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Select $title'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: options
                .map((opt) => ListTile(
              title: Text(opt),
              onTap: () => Navigator.pop(context, opt),
            ))
                .toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isSmall = width < 400;

    return SafeArea(
      child: Column(
        children: [
          // ---------- Top Stats Cards ----------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
            child: GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: isSmall ? 2 : 4,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: isSmall ? 1.1 : 1.3,
              children: const [
                StatusCard(title: "Low Battery", count: 12, color: Colors.red, icon: Icons.battery_alert),
                StatusCard(title: "In Maintenance", count: 3, color: Colors.orange, icon: Icons.build),
                StatusCard(title: "Active", count: 78, color: Colors.green, icon: Icons.directions_bike),
                StatusCard(title: "Offline", count: 2, color: Colors.grey, icon: Icons.signal_cellular_off),
              ],
            ),
          ),

          // ---------- Map and Buttons ----------
          Expanded(
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: _initialPosition,
                  markers: _createMarkers(),
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                ),

                // ---------- Filter Chips ----------
                Positioned(
                  top: 10,
                  left: 10,
                  right: 10,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const SizedBox(width: 4),
                        FilterButton(
                          label: "Vehicle Type",
                          isSelected: _selectedFilter == "Vehicle Type",
                          onTap: () => _onFilterSelected("Vehicle Type"),
                        ),
                        const SizedBox(width: 6),
                        FilterButton(
                          label: "Battery %",
                          isSelected: _selectedFilter == "Battery %",
                          onTap: () => _onFilterSelected("Battery %"),
                        ),
                        const SizedBox(width: 6),
                        FilterButton(
                          label: "Zone",
                          isSelected: _selectedFilter == "Zone",
                          onTap: () => _onFilterSelected("Zone"),
                        ),
                        const SizedBox(width: 6),
                        FilterButton(
                          label: "Status",
                          isSelected: _selectedFilter == "Status",
                          onTap: () => _onFilterSelected("Status"),
                        ),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                ),

                // ---------- Floating Buttons (Right) ----------
                Positioned(
                  bottom: 80,
                  right: 14,
                  child: Column(
                    children: [
                      _fab(icon: Icons.add, tag: "add"),
                      const SizedBox(height: 8),
                      _fab(icon: Icons.filter_list, tag: "filter"),
                    ],
                  ),
                ),

                // ---------- My Location (Left) ----------
                Positioned(
                  bottom: 80,
                  left: 14,
                  child: _fab(icon: Icons.my_location, tag: "loc"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _fab({required IconData icon, required String tag}) {
    return FloatingActionButton.small(
      onPressed: () {},
      heroTag: tag,
      elevation: 2,
      backgroundColor: Colors.white,
      foregroundColor: Colors.blue,
      child: Icon(icon, size: 20),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      const Marker(
        markerId: MarkerId('1'),
        position: LatLng(11.5842, 37.3714),
        infoWindow: InfoWindow(title: 'Vehicle 1'),
      ),
      const Marker(
        markerId: MarkerId('2'),
        position: LatLng(9.04, 38.76),
        infoWindow: InfoWindow(title: 'Vehicle 2'),
      ),
    };
  }
}

// -------------------- Status Card -------------------- //

class StatusCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;
  final IconData icon;

  const StatusCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        elevation: 1.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 14),
              Text(
                '$count',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: color,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 7,
                  color: Colors.black87,
                  height: 0.8,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------- Filter Button -------------------- //

class FilterButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? Colors.blue[100] : Colors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Colors.blue[900] : Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

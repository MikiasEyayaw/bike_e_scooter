import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false, _biometricLogin = true;
  String _vehicle = 'Bike', _language = 'English';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.grey[50],
    appBar: AppBar(
      title: const Text(
        'Profile & Settings',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
    ),
    body: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildPersonalDetails(),
        const SizedBox(height: 24),
        _section("Preferences", _buildPreferences()),
        _section("Security", _buildSecurity()),
        _section("Support", _buildSupport()),
        const SizedBox(height: 32),
        _logoutButton(),
      ],
    ),
  );

  Widget _buildPersonalDetails() => _buildCard(
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[100],
          child: const Icon(Icons.person, size: 30, color: Colors.green),
        ),
        const SizedBox(width: 16),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kebede',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                '+251 912 345 678',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.verified, color: Colors.green, size: 16),
                  SizedBox(width: 4),
                  Text(
                    'Verified ID',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => debugPrint('Edit profile tapped'),
          icon: const Icon(Icons.edit, color: Colors.green),
        ),
      ],
    ),
  );

  Widget _section(String title, Widget child) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
          ),
        ),
      ),
      child,
    ],
  );

  Widget _buildPreferences() => _buildCard(
    children: [
      _tile(
        'Preferred Vehicle Type',
        DropdownButton<String>(
          value: _vehicle,
          items: [
            'Bike',
            'E-Scooter',
            'Both',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _vehicle = v!),
          underline: const SizedBox(),
        ),
      ),
      _divider(),
      _tile(
        'Language',
        DropdownButton<String>(
          value: _language,
          items: [
            'English',
            'Amharic',
            'Arabic',
            'French',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _language = v!),
          underline: const SizedBox(),
        ),
      ),
      _divider(),
      _tile(
        'Dark Mode',
        Switch(
          value: _darkMode,
          onChanged: (v) => setState(() => _darkMode = v),
          activeColor: Colors.green,
        ),
      ),
    ],
  );

  Widget _buildSecurity() => _buildCard(
    children: [
      _tile(
        'Change Password',
        const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => debugPrint('Change password tapped'),
      ),
      _divider(),
      _tile(
        'Biometric Login',
        Switch(
          value: _biometricLogin,
          onChanged: (v) => setState(() => _biometricLogin = v),
          activeColor: Colors.green,
        ),
      ),
    ],
  );

  Widget _buildSupport() => _buildCard(
    children: [
      _tile(
        'Frequently Asked Questions',
        const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () => debugPrint('FAQ tapped'),
      ),
    ],
  );

  Widget _logoutButton() => SizedBox(
    height: 50,
    child: OutlinedButton(
      onPressed: _confirmLogout,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );

  // Shared Helpers
  Widget _buildCard({Widget? child, List<Widget>? children}) => Card(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: child ?? Column(children: children!),
    ),
  );

  Widget _tile(String title, Widget trailing, {VoidCallback? onTap}) =>
      ListTile(title: Text(title), trailing: trailing, onTap: onTap);

  Widget _divider() => const Divider(height: 1);

  void _confirmLogout() => showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            debugPrint('User logged out');
          },
          child: const Text('Logout', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
}

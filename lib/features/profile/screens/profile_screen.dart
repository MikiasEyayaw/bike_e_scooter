import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _darkMode = false, _biometricLogin = true;
  String _vehicle = 'Bike', _language = 'English';
  String _name = 'Kebede', _phone = '+251 912 345 678';

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _darkMode ? Colors.grey[900]! : Colors.grey[50]!;
    final cardColor = _darkMode ? Colors.grey[850]! : Colors.white;
    final textColor = _darkMode ? Colors.white : Colors.black;
    final subtitleColor = _darkMode ? Colors.grey[400]! : Colors.grey;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile & Settings',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: textColor,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: textColor,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPersonalDetails(cardColor, textColor, subtitleColor),
          const SizedBox(height: 24),
          _section(
            "Preferences",
            _buildPreferences(cardColor, textColor),
            textColor,
          ),
          _section("Security", _buildSecurity(cardColor, textColor), textColor),
          _section("Support", _buildSupport(cardColor, textColor), textColor),
          const SizedBox(height: 32),
          _logoutButton(),
        ],
      ),
    );
  }

  Widget _buildPersonalDetails(
    Color cardColor,
    Color textColor,
    Color subtitleColor,
  ) => _buildCard(
    cardColor: cardColor,
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: Colors.green[100],
          child: Icon(Icons.person, size: 30, color: Colors.green),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: 4),
              Text(
                _phone,
                style: TextStyle(fontSize: 14, color: subtitleColor),
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
          onPressed: _editProfileDialog,
          icon: Icon(Icons.edit, color: Colors.green),
        ),
      ],
    ),
  );

  Widget _section(String title, Widget child, Color textColor) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(left: 8, bottom: 8),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor.withOpacity(0.7),
          ),
        ),
      ),
      child,
    ],
  );

  Widget _buildPreferences(Color cardColor, Color textColor) => _buildCard(
    cardColor: cardColor,
    children: [
      _tile(
        'Preferred Vehicle Type',
        DropdownButton<String>(
          value: _vehicle,
          dropdownColor: cardColor,
          style: TextStyle(color: textColor),
          items: [
            'Bike',
            'E-Scooter',
            'Both',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _vehicle = v!),
          underline: const SizedBox(),
        ),
        textColor: textColor,
      ),
      _divider(),
      _tile(
        'Language',
        DropdownButton<String>(
          value: _language,
          dropdownColor: cardColor,
          style: TextStyle(color: textColor),
          items: [
            'English',
            'Amharic',
            'Arabic',
            'French',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => _language = v!),
          underline: const SizedBox(),
        ),
        textColor: textColor,
      ),
      _divider(),
      _tile(
        'Dark Mode',
        Switch(
          value: _darkMode,
          onChanged: (v) => setState(() => _darkMode = v),
          activeColor: Colors.green,
        ),
        textColor: textColor,
      ),
    ],
  );

  Widget _buildSecurity(Color cardColor, Color textColor) => _buildCard(
    cardColor: cardColor,
    children: [
      _tile(
        'Change Password',
        const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: _changePasswordDialog,
        textColor: textColor,
      ),
      _divider(),
      _tile(
        'Biometric Login',
        Switch(
          value: _biometricLogin,
          onChanged: (v) => setState(() => _biometricLogin = v),
          activeColor: Colors.green,
        ),
        textColor: textColor,
      ),
    ],
  );

  Widget _buildSupport(Color cardColor, Color textColor) => _buildCard(
    children: [
      _tile(
        'FAQ',
        const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const _FAQScreen()),
          );
        },
        textColor: textColor,
      ),
    ],
  );

  Widget _logoutButton() => SizedBox(
    height: 50,
    child: OutlinedButton(
      onPressed: _confirmLogout,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: BorderSide(color: Colors.red),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Logout',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );

  Widget _buildCard({
    Widget? child,
    List<Widget>? children,
    Color cardColor = Colors.white,
  }) => Card(
    elevation: 2,
    color: cardColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: child ?? Column(children: children!),
    ),
  );

  Widget _tile(
    String title,
    Widget trailing, {
    VoidCallback? onTap,
    Color textColor = Colors.black,
  }) => ListTile(
    title: Text(title, style: TextStyle(color: textColor)),
    trailing: trailing,
    onTap: onTap,
  );

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

  // --- Edit Profile ---
  void _editProfileDialog() {
    final nameController = TextEditingController(text: _name);
    final phoneController = TextEditingController(text: _phone);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _name = nameController.text;
                _phone = phoneController.text;
              });
              Navigator.pop(context);
              _showSuccessDialog('Profile updated successfully!');
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // --- Password Dialogs ---
  void _changePasswordDialog() {
    final currentController = TextEditingController();
    final newController = TextEditingController();
    final confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
            ),
            TextField(
              controller: newController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
            ),
            TextField(
              controller: confirmController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (currentController.text.isEmpty ||
                  newController.text.isEmpty ||
                  confirmController.text.isEmpty ||
                  newController.text != confirmController.text) {
                Navigator.pop(context);
                _showTryAgainDialog(
                  'Password change failed. Please check your inputs.',
                );
              } else {
                Navigator.pop(context);
                _showSuccessDialog('Password changed successfully.');
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _showTryAgainDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Try Again'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// --- FAQ Screen ---
class _FAQScreen extends StatelessWidget {
  const _FAQScreen({super.key});

  final List<Map<String, String>> faqs = const [
    {
      "question": "How do I unlock a bike or e-scooter?",
      "answer": "Select a vehicle, scan the QR code, and start your ride.",
    },
    {
      "question": "How is the ride charged?",
      "answer": "You are charged per minute of the ride.",
    },
    {
      "question": "What if the vehicle is damaged?",
      "answer":
          "Report the issue immediately via the app before starting a ride.",
    },
    {
      "question": "Can I pause my ride?",
      "answer":
          "Yes, some vehicles support pausing. Check the vehicle status on the app.",
    },
    {
      "question": "How do I end my ride?",
      "answer": "Park at a legal location and press 'End Ride' in the app.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqs.length,
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return ExpansionTile(
            title: Text(
              faq['question']!,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(faq['answer']!),
              ),
            ],
          );
        },
      ),
    );
  }
}

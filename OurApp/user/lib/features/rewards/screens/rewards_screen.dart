import 'package:flutter/material.dart';

void main() {
  runApp(const RewardsScreen());
}

class RewardsScreen extends StatelessWidget {
  const RewardsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rewards & Gamification',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const RewardsPage(),
    );
  }
}

class RewardsPage extends StatelessWidget {
  const RewardsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          'Rewards & Gamification',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Eco Level',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 6),
            const Text(
              'Eco Warrior - Level 3',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: 0.7,
                backgroundColor: Colors.grey.shade200,
                color: Colors.green,
                minHeight: 8,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Only 300 points to Level 4! Keep riding.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 20),
            Row(
              children: const [
                Icon(Icons.flash_on, color: Colors.green, size: 26),
                SizedBox(width: 8),
                Text(
                  '2350 Eco Points',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Active Missions',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            MissionCard(
              icon: Icons.directions_bike,
              title: 'Ride 5km This Week',
              description: 'Complete 5km of rides to earn 10 Birr credit',
              progress: 0.6,
              progressText: 'Progress: 3/5 km ridden',
            ),
            MissionCard(
              icon: Icons.group_add,
              title: 'Refer 3 Friends',
              description: 'Invite 3 friends to eRide and get a free ride',
              progress: 0.33,
              progressText: 'Progress: 1/3 friends referred',
            ),
            MissionCard(
              icon: Icons.location_on,
              title: 'Unlock a New Zone',
              description: 'Explore a new eRide zone to earn bonus Eco Points',
              progress: 0.8,
              progressText: 'Progress: 4/5 zones explored',
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LeaderboardPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'View Leaderboard',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MissionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final double progress;
  final String progressText;

  const MissionCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.description,
    required this.progress,
    required this.progressText,
  }) : super(key: key);

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: Text(widget.title),
              content: Text(
                '${widget.description}\n\n${widget.progressText}\nKeep going to complete this mission!',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(), // FIXED
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _hovering
                    ? Colors.green.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: _hovering ? 10 : 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.green.shade100,
                  child: Icon(widget.icon, color: Colors.green.shade700),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.description,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: widget.progress,
                          backgroundColor: Colors.grey.shade200,
                          color: Colors.green,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.progressText,
                        style: const TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  final List<Map<String, dynamic>> users = const [
    {'name': 'Alice', 'points': 2500},
    {'name': 'Bob', 'points': 2200},
    {'name': 'Charlie', 'points': 2000},
    {'name': 'David', 'points': 1800},
    {'name': 'Eva', 'points': 1500},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.green,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.green.shade100,
              child: Text('${index + 1}'),
            ),
            title: Text(user['name']),
            trailing: Text(
              '${user['points']} pts',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }
}

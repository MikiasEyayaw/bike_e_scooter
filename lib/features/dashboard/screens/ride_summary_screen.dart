import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart'; // for clipboard copy (download simulation)

class RideSummaryScreen extends StatelessWidget {
  const RideSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy ride data
    const distance = 3.5; // km
    const duration = 25; // min
    const fare = 35; // ETB
    const co2Saved = 0.8; // kg
    const kcalBurned = 200;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Ride Summary',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.emoji_events, size: 60, color: Colors.green),
              const SizedBox(height: 16),
              const Text(
                'Ride Completed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Great job on your ride, we hope you enjoyed it!',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // Info boxes
              _infoBox(distance, duration, fare, co2Saved),

              const SizedBox(height: 20),

              _ecoImpactBox(co2Saved, kcalBurned),

              const SizedBox(height: 20),

              _ratingBox(),

              const SizedBox(height: 24),

              // Confirm Payment Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _showPaymentDialog(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Confirm Payment',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              _outlineButton(
                text: 'Download Receipt',
                icon: Icons.download,
                onPressed: () async {
                  // Simulate saving receipt by copying text to clipboard
                  await Clipboard.setData(const ClipboardData(
                    text: 'Receipt #12345\nRide: 3.5km - 35 ETB\nThanks!',
                  ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Receipt copied to clipboard!'),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              _outlineButton(
                text: 'Share My Ride Impact',
                icon: Icons.share,
                onPressed: () {
                  Share.share(
                    'I just completed a 3.5 km eco-friendly ride and saved 0.8 kg of CO₂! 🌍💚',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ======= Widgets ========

  Widget _infoBox(
      double distance, int duration, int fare, double co2Saved) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile(Icons.route, '$distance km', 'Distance'),
              _infoTile(Icons.access_time, '$duration min', 'Duration'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoTile(Icons.attach_money, '$fare ETB', 'Fare'),
              _infoTile(Icons.eco, '$co2Saved kg', 'CO₂ Saved'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ecoImpactBox(double co2Saved, int kcalBurned) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Eco Impact',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.eco, color: Colors.green, size: 20),
                  const SizedBox(width: 6),
                  Text('$co2Saved kg CO₂ avoided',
                      style: const TextStyle(color: Colors.black87)),
                ],
              ),
              Row(
                children: [
                  const Icon(Icons.local_fire_department,
                      color: Colors.orange, size: 20),
                  const SizedBox(width: 6),
                  Text('$kcalBurned kcal burned',
                      style:
                          const TextStyle(color: Colors.orangeAccent)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ratingBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rate Your Ride',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => IconButton(
                onPressed: () {},
                icon: Icon(Icons.star,
                    color: i < 4 ? Colors.amber : Colors.grey[300], size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _outlineButton({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.black54),
        label: Text(text, style: const TextStyle(color: Colors.black87)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.grey),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  // ======== Payment Dialog ========

  void _showPaymentDialog(BuildContext context) {
    final amountController = TextEditingController(text: '100.00');
    String selectedMethod = 'Telebirr';

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text('Add Funds',
              style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter amount and select a payment method.'),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Amount (ETB)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  RadioListTile<String>(
                    value: 'Telebirr',
                    groupValue: selectedMethod,
                    title: const Text('Telebirr'),
                    onChanged: (v) {
                      selectedMethod = v!;
                      (ctx as Element).markNeedsBuild();
                    },
                  ),
                  RadioListTile<String>(
                    value: 'CBE Birr',
                    groupValue: selectedMethod,
                    title: const Text('CBE Birr'),
                    onChanged: (v) {
                      selectedMethod = v!;
                      (ctx as Element).markNeedsBuild();
                    },
                  ),
                  RadioListTile<String>(
                    value: 'Credit/Debit Card',
                    groupValue: selectedMethod,
                    title: const Text('Credit/Debit Card'),
                    onChanged: (v) {
                      selectedMethod = v!;
                      (ctx as Element).markNeedsBuild();
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          'Processing ${amountController.text} ETB via $selectedMethod...'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Confirm'),
              ),
            ),
          ],
        );
      },
    );
  }

  // ===== Helper Tile =====
  Widget _infoTile(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 22),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

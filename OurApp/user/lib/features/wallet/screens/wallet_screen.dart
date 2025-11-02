import 'package:flutter/material.dart';

void main() {
  runApp(const WalletScreen());
}

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Wallet',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MyWalletScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyWalletScreen extends StatefulWidget {
  const MyWalletScreen({super.key});

  @override
  State<MyWalletScreen> createState() => _MyWalletScreenState();
}

class _MyWalletScreenState extends State<MyWalletScreen> {
  double balance = 1250.5;
  bool autoTopUp = false;
  bool showTransactions = false;

  List<Map<String, String>> paymentMethods = [
    {"name": "Telebirr", "number": "**** 1234"},
    {"name": "CBE Birr", "number": "**** 5678"},
    {"name": "Credit/Debit Card", "number": "**** 9012"},
  ];

  List<Map<String, String>> transactions = [
    {"type": "Ride Payment", "amount": "- ETB 35", "date": "Oct 30, 2025"},
    {"type": "Bonus", "amount": "+ ETB 50", "date": "Oct 25, 2025"},
  ];

  // ---------------- Add Funds Dialog ----------------
  void showAddFundsDialog() {
    final TextEditingController amountController = TextEditingController(
      text: "100.00",
    );
    String selectedMethod = paymentMethods[0]["name"]!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "Add Funds",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Enter amount and select a payment method.",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 15),

                  // Amount Field
                  const Text(
                    "Amount (ETB)",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: amountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    "Select Payment Method",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),

                  // Radio Buttons for Payment Methods
                  for (var method in paymentMethods)
                    RadioListTile<String>(
                      title: Text(method["name"]!),
                      value: method["name"]!,
                      groupValue: selectedMethod,
                      onChanged: (value) {
                        setState(() {
                          selectedMethod = value!;
                        });
                      },
                      activeColor: Colors.green,
                      contentPadding: EdgeInsets.zero,
                    ),

                  const SizedBox(height: 10),

                  // Confirm Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        double enteredAmount =
                            double.tryParse(amountController.text) ?? 0.0;

                        if (enteredAmount > 0) {
                          addFunds(enteredAmount, selectedMethod);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter a valid amount."),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        "Confirm",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // ---------------- Core Actions ----------------
  void addFunds(double amount, String method) {
    setState(() {
      balance += amount;
      transactions.insert(0, {
        "type": "Top-Up via $method",
        "amount": "+ ETB ${amount.toStringAsFixed(2)}",
        "date": "Now",
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("ETB ${amount.toStringAsFixed(2)} added via $method."),
      ),
    );
  }

  void toggleTransactions() {
    setState(() => showTransactions = !showTransactions);
  }

  void addNewCard() {
    setState(() {
      int newNumber = 9000 + paymentMethods.length;
      paymentMethods.add({
        "name": "New Card ${paymentMethods.length + 1}",
        "number": "**** $newNumber",
      });
    });
  }

  void toggleAutoTopUp(bool value) {
    setState(() => autoTopUp = value);
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wallet'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- Balance Card ----
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Balance',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'ETB ${balance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: showAddFundsDialog,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('+ Add Funds'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: toggleTransactions,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            showTransactions
                                ? 'Hide Transactions'
                                : 'View Transactions',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),

            // ---- Payment Methods ----
            const Text(
              'Payment Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Column(
              children: paymentMethods.map((method) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.credit_card,
                        color: Colors.green,
                        size: 28,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method["name"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              method["number"]!,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),

            // Add New Card Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: TextButton.icon(
                onPressed: addNewCard,
                icon: const Icon(Icons.add, color: Colors.green),
                label: const Text(
                  'Add New Card',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ---- Auto Top-Up ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto Top-Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Automatically add funds when balance is low.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: autoTopUp,
                  onChanged: toggleAutoTopUp,
                  activeColor: Colors.green,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ---- Transactions Section ----
            if (showTransactions) ...[
              const Text(
                'Recent Transactions',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              if (transactions.isEmpty)
                const Text(
                  'No transactions yet.',
                  style: TextStyle(color: Colors.grey),
                )
              else
                Column(
                  children: transactions.map((tx) {
                    bool isPositive = tx["amount"]!.contains("+");
                    return ListTile(
                      leading: Icon(
                        isPositive ? Icons.arrow_downward : Icons.arrow_upward,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                      title: Text(tx["type"]!),
                      subtitle: Text(tx["date"]!),
                      trailing: Text(
                        tx["amount"]!,
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

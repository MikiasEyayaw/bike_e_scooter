import 'package:flutter/material.dart';
import '../../auth/screen/verification.dart';
import '../widgets/support_tile.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Image.asset('assets/images/support/find_unlock.png',width: 300, height: 300,),
            SizedBox(height: 30),

            Text('Find & Unlock Bikes Easily',style: TextStyle(fontSize:30, fontWeight: FontWeight.bold ),),
            Center(
                child: Text('Locate available e-bikes and'
                    '\n e-scooters nearby on the map.'
                    '\n Scan a QR code or enter a code to'
                    '\n unlock your ride in seconds.',
                  style: TextStyle(fontSize: 17,color: Colors.black87,letterSpacing: 0.3),
                ),
            ),
            SizedBox(height: 10,),
            const Text(
              'Enjoy your journey with our eco-friendly rides.\n'
                  'Park responsibly in designated zones and pay\n'
                  'securely through the app upon completion.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.6, // improves line spacing
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30,),

            ElevatedButton(
                onPressed: (){
                Navigator.push(
                    context,MaterialPageRoute(builder: (context)=>const VerificationScreen())
                );

            },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),

                child: Text('Next', style: TextStyle(fontSize: 30),))

          ],

          // children:ListView(
          //   children: const [
          //     SupportTile(title: 'How to start a ride?', content: 'Scan the QR code on the scooter.'),
          //     SupportTile(title: 'Payment issue?', content: 'Contact support@ridenow.app'),
          //   ],
          // ),

        ),
      ),

    );
  }
}

import 'package:flutter/material.dart';

class SmsExampleCard extends StatelessWidget {
  const SmsExampleCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Bank SMS
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.message, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("JK-SBIUPI • Messages • 2min",
                        style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 4),
                    Text("A/C X6489 debited by 73.0 on 17th Jan 25",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12),

        // App response
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.savings, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("₹73 Recorded! • Expensio • 1min",
                        style: TextStyle(color: Colors.white70)),
                    SizedBox(height: 4),
                    Text("Open the app to categorize your transaction.",
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

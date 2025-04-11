import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:flutter/material.dart';

class DashboardTransactionCard extends StatefulWidget {
  final UserTransaction transaction;
  const DashboardTransactionCard({required this.transaction, super.key});

  @override
  State<DashboardTransactionCard> createState() =>
      _DashboardTransactionCardState();
}

class _DashboardTransactionCardState extends State<DashboardTransactionCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0E10), // dark card color
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text('hello')),
          ),

          const SizedBox(width: 12),

          // Text Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'this is expense',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹2342',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Add Button
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add, color: Colors.grey),
            label: const Text(
              "Add",
              style: TextStyle(color: Colors.grey),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}

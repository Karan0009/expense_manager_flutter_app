import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/layouts/above_navbar_layout.dart';
import 'package:expense_manager/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoTransactionsWidget extends ConsumerWidget {
  const NoTransactionsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AboveNavbarLayout(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: Image.asset(
                      'assets/images/piggy_empty_state_1.png',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  Text(
                    'No Expense Added',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your expenses will be automatically added.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.w400,
                          color:
                              ColorsConfig.textColor2.withValues(alpha: 0.75),
                        ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 4, right: 4),
            child: SizedBox(
              width: double.infinity,
              child: CustomButton(
                  onPressed: () => _showAddExpenseBottomSheet(context),
                  isLoading: false,
                  buttonText: 'Add Manually'),
            ),
          ),
        ],
      ),
    );
  }
}

void _showAddExpenseBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    barrierColor: Colors.black.withValues(alpha: 0.5), // Darkens backdrop
    backgroundColor: Colors.transparent, // Make modal container transparent
    builder: (context) {
      return Stack(
        children: [
          // Backdrop with Close Button
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: IconButton(
                icon: Icon(Icons.close, size: 28, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),

          // Actual Modal Container
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Add Expense",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  SizedBox(height: 12),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "Expense Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Amount",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add expense logic here
                        Navigator.pop(context);
                      },
                      child: Text("Save Expense"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

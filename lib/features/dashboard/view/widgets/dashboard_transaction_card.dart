import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:expense_manager/core/helpers/transaction_helpers.dart';
import 'package:expense_manager/data/models/transactions/user_transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardTransactionCard extends StatefulWidget {
  final UserTransaction? transaction;
  const DashboardTransactionCard({required this.transaction, super.key});

  @override
  State<DashboardTransactionCard> createState() =>
      _DashboardTransactionCardState();
}

class _DashboardTransactionCardState extends State<DashboardTransactionCard> {
  @override
  Widget build(BuildContext context) {
    if (widget.transaction == null) {
      return Text(
        'Err loading transaction',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: ColorsConfig.bgColor2,
        boxShadow: [
          BoxShadow(
            color: ColorsConfig.bgShadowColor1,
            offset: Offset(0, 4),
            blurRadius: 5,
            spreadRadius: 0,
          )
        ],
        border: Border.all(
          color: ColorsConfig.color5,
          width: 1,
          style: BorderStyle.solid,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: ColorsConfig.color5,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
                child: Text(widget.transaction!.recipientName
                    .substring(0, 2)
                    .toUpperCase())),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.transaction!.recipientName,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: ColorsConfig.textColor5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('dd MMM, yyyy').format(
                      widget.transaction!.transactionDatetime ??
                          DateTime.now()),
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        color: ColorsConfig.textColor5,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  TransactionHelpers.formatStringAmount(
                      widget.transaction!.amount),
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: ColorsConfig.textColor4,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.add,
              size: 24,
              color: ColorsConfig.textColor3,
            ),
            label: Text(
              "Add",
              style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    color: ColorsConfig.textColor5,
                  ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: ColorsConfig.color1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
            ),
          ),
        ],
      ),
    );
  }
}

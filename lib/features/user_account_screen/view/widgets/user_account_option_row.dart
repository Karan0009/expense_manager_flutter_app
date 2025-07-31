import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class UserAccountOptionRow extends StatelessWidget {
  final IconData icon;
  final String optionName;
  final void Function()? onPressed;
  final String? value;
  const UserAccountOptionRow({
    super.key,
    required this.icon,
    required this.optionName,
    required this.onPressed,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   color: Colors.red,
      //   borderRadius: BorderRadius.circular(8),
      // ),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: ColorsConfig.textColor5,
                size: 18,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                optionName,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: ColorsConfig.textColor5,
                    ),
              ),
            ],
          ), // Add some space on the left
          SizedBox(
            height: 16,
            child: value == null
                ? TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.all(0),
                    ),
                    onPressed: onPressed,
                    icon: const Icon(
                      Icons.add,
                      size: 12,
                      color: ColorsConfig.textColor1,
                    ),
                    label: Text(
                      "Add",
                      style: Theme.of(context).textTheme.labelMedium!.copyWith(
                            fontSize: 14,
                            color: ColorsConfig.textColor1,
                          ),
                    ),
                  )
                : Text(
                    value ?? '',
                  ),
          ), // Add some space between icon and text
        ],
      ),
    );
  }
}

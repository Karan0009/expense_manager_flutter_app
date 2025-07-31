import 'package:expense_manager/config/themes/colors_config.dart';
import 'package:flutter/material.dart';

class UserAccountListItem extends StatelessWidget {
  final IconData icon;
  final String optionName;
  final void Function()? onPressed;
  const UserAccountListItem({
    super.key,
    required this.icon,
    required this.optionName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}

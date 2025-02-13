import 'package:flutter/material.dart';
import 'package:teck_app/theme/colors.dart';

class CardButton extends StatelessWidget {
  final VoidCallback onPress;
  final IconData icon;
  final Color color;
  final Color iconColor;
  final String name;

  const CardButton({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.color,
    required this.iconColor,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: color,
        child: Container(
          width: 140,
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 35, color: iconColor),
              const SizedBox(height: 4),
              Text(
                name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onPrincipalBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

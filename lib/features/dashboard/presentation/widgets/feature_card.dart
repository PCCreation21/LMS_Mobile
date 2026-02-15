import 'package:flutter/material.dart';
import 'package:loan_management_system/app/theme/app_colors.dart';

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.primaryButton,
    this.secondaryButton,
    this.primaryColor = const Color.fromARGB(255, 130, 184, 158),
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  final IconData icon;
  final String title;
  final String description;
  final String primaryButton;
  final String? secondaryButton;
  final Color primaryColor;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            blurRadius: 16,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.08),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.secondary),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6F9985),
                foregroundColor: AppColors.secondary,
              ),
              onPressed: onPrimaryPressed,
              child: Text(primaryButton),
            ),
          ),
          if (secondaryButton != null) ...[
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onSecondaryPressed,
                child: Text(secondaryButton!),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

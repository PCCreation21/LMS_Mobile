import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 140, this.showText = false});

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/images/logo.png',
          width: size,
          height: size,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported, size: size, color: Colors.grey);
          },
        ),

        if (showText) ...[
          const SizedBox(height: 16),

          const Text(
            "GOLDEN CASH",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
              color: Color(0xFFECE7DA),
            ),
          ),

          const SizedBox(height: 6),

          const Text(
            "MICRO CREDIT INVESTMENT (PVT) LTD.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              letterSpacing: 1.5,
              color: Color(0xFFC9B36C),
            ),
          ),
        ],
      ],
    );
  }
}

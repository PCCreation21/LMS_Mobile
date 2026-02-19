import 'package:flutter/material.dart';

class KvRow extends StatelessWidget {
  const KvRow({
    super.key,
    required this.label,
    required this.value,
    this.boldValue = true,
    this.valueColor,
  });

  final String label;
  final String value;
  final bool boldValue;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.black.withOpacity(0.65),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              fontWeight: boldValue ? FontWeight.w900 : FontWeight.w700,
              color: valueColor ?? Colors.black.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../domain/loan_package_models.dart';

class LoanPackageCard extends StatelessWidget {
  const LoanPackageCard({
    super.key,
    required this.row,
    required this.onEdit,
    required this.onDelete,
  });

  final LoanPackageRowModel row;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  String _date(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row: code + date + interest + edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.packageCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F5B49),
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Text(
                        "${row.interestRatePercent.toStringAsFixed(0)}%",
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFD6A11E),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            row.packageName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            "Time Period:  ${row.timePeriodDays} days",
            style: TextStyle(color: Colors.black.withOpacity(0.65)),
          ),
        ],
      ),
    );
  }
}

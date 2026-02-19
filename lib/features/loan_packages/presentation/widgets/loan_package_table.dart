import 'package:flutter/material.dart';
import '../../domain/loan_package_models.dart';

class LoanPackageTable extends StatelessWidget {
  const LoanPackageTable({
    super.key,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  final List<LoanPackageRowModel> rows;
  final ValueChanged<LoanPackageRowModel> onEdit;
  final ValueChanged<LoanPackageRowModel> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 60,
          columns: const [
            DataColumn(label: Text("Package Code")),
            DataColumn(label: Text("Package Name")),
            DataColumn(label: Text("Time Period")),
            DataColumn(label: Text("Interest")),
            DataColumn(label: Text("Actions")),
          ],
          rows: rows.map((p) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    p.packageCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F5B49),
                    ),
                  ),
                ),
                DataCell(Text(p.packageName)),
                DataCell(Text("${p.timePeriodDays} days")),
                DataCell(Text("${p.interestRatePercent.toStringAsFixed(0)}%")),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => onEdit(p),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () => onDelete(p),
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

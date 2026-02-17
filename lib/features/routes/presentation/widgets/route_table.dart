import 'package:flutter/material.dart';
import '../../domain/route_models.dart';

class RouteTable extends StatelessWidget {
  const RouteTable({
    super.key,
    required this.rows,
    required this.onEdit,
    required this.onDelete,
  });

  final List<RouteRowModel> rows;
  final ValueChanged<RouteRowModel> onEdit;
  final ValueChanged<RouteRowModel> onDelete;

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
            DataColumn(label: Text("Route Code")),
            DataColumn(label: Text("Route Name")),
            DataColumn(label: Text("Route Description")),
            DataColumn(label: Text("Actions")),
          ],
          rows: rows.map((r) {
            return DataRow(
              cells: [
                DataCell(
                  Text(
                    r.routeCode,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1F5B49),
                    ),
                  ),
                ),
                DataCell(Text(r.routeName)),
                DataCell(SizedBox(width: 360, child: Text(r.routeDescription))),
                DataCell(
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => onEdit(r),
                        icon: const Icon(Icons.edit_outlined),
                      ),
                      IconButton(
                        onPressed: () => onDelete(r),
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

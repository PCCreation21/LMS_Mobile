import 'package:flutter/material.dart';
import '../../domain/route_collection_models.dart';

class RouteCollectionTable extends StatelessWidget {
  const RouteCollectionTable({super.key, required this.rows});

  final List<RouteCollectionRow> rows;

  String _money(double v) => "LKR ${v.toStringAsFixed(0)}";
  String _date(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _statusText(CollectionStatus s) {
    switch (s) {
      case CollectionStatus.completed:
        return "Completed";
      case CollectionStatus.partial:
        return "Partial";
      case CollectionStatus.noCollection:
        return "No Collection";
    }
  }

  Color _statusBg(CollectionStatus s) {
    switch (s) {
      case CollectionStatus.completed:
        return const Color(0xFFDDE7E2);
      case CollectionStatus.partial:
        return const Color(0xFFFFF0D1);
      case CollectionStatus.noCollection:
        return const Color(0xFFE9EEEC);
    }
  }

  Color _statusFg(CollectionStatus s) {
    switch (s) {
      case CollectionStatus.completed:
        return const Color(0xFF1F5B49);
      case CollectionStatus.partial:
        return const Color(0xFFB07700);
      case CollectionStatus.noCollection:
        return Colors.black.withOpacity(0.6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowHeight: 44,
          dataRowMinHeight: 44,
          dataRowMaxHeight: 56,
          columns: const [
            DataColumn(label: Text("Route Code")),
            DataColumn(label: Text("Route Name")),
            DataColumn(label: Text("Route Officer")),
            DataColumn(label: Text("Total Customers")),
            DataColumn(label: Text("Total Collected")),
            DataColumn(label: Text("Collection Date")),
            DataColumn(label: Text("Status")),
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
                DataCell(Text(r.officer)),
                DataCell(Text("${r.totalCustomers}")),
                DataCell(
                  Text(
                    _money(r.totalCollected),
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                DataCell(Text(_date(r.collectionDate))),
                DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _statusBg(r.status),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      _statusText(r.status),
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: _statusFg(r.status),
                      ),
                    ),
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

import 'package:flutter/material.dart';
import '../../domain/route_collection_models.dart';

class RouteCollectionCard extends StatelessWidget {
  const RouteCollectionCard({super.key, required this.row});

  final RouteCollectionRow row;

  String _money(double v) => "LKR ${v.toStringAsFixed(0)}";

  String _date(DateTime d) {
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return "$y-$m-$dd";
  }

  ({String text, Color bg, Color fg}) _status(CollectionStatus s) {
    switch (s) {
      case CollectionStatus.completed:
        return (
          text: "Completed",
          bg: const Color(0xFF3F6B5F),
          fg: Colors.white,
        );
      case CollectionStatus.partial:
        return (text: "Partial", bg: const Color(0xFFD6A11E), fg: Colors.white);
      case CollectionStatus.noCollection:
        return (
          text: "No Collection",
          bg: const Color(0xFFBFC8C4),
          fg: Colors.white,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final st = _status(row.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // top row: code + date + status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.routeCode,
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1F5B49),
                  fontSize: 18,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(_date(row.collectionDate)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: st.bg,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      st.text,
                      style: TextStyle(
                        color: st.fg,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 6),
          Text(
            row.routeName,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 6),
          Text(
            "Officer: ${row.officer}",
            style: TextStyle(color: Colors.black.withOpacity(0.65)),
          ),

          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.black.withOpacity(0.08)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Customers:",
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
              ),
              Text(
                "${row.totalCustomers}",
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
              const SizedBox(width: 18),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  "Total Collected:",
                  style: TextStyle(color: Colors.black.withOpacity(0.7)),
                ),
              ),

              const SizedBox(width: 18),
              Text(
                _money(row.totalCollected),
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

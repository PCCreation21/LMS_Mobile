import 'package:flutter/material.dart';
import '../../domain/route_models.dart';

class RouteCard extends StatelessWidget {
  const RouteCard({super.key, required this.row, required this.onEdit});

  final RouteRowModel row;
  final VoidCallback onEdit;

  String _date(DateTime? d) {
    if (d == null) return "";
    final y = d.year.toString().padLeft(4, '0');
    final m = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    return "$y-$m-$dd";
  }

  ({Color bg, Color fg}) _statusColor(String? s) {
    if (s == null) return (bg: Colors.transparent, fg: Colors.transparent);
    final v = s.toLowerCase();
    if (v == "completed")
      return (bg: const Color(0xFF3F6B5F), fg: Colors.white);
    if (v == "partial") return (bg: const Color(0xFFD6A11E), fg: Colors.white);
    return (bg: const Color(0xFFBFC8C4), fg: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final st = _statusColor(row.status);

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
          // top row: code + date/status
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
                  if (row.date != null) Text(_date(row.date)),
                  const SizedBox(height: 6),
                  if (row.status != null)
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
                        row.status!,
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

          if (row.officerName != null)
            Text(
              "Officer: ${row.officerName!}",
              style: TextStyle(color: Colors.black.withOpacity(0.65)),
            ),

          const SizedBox(height: 10),
          Divider(height: 1, color: Colors.black.withOpacity(0.08)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Text(
                  row.routeDescription,
                  style: TextStyle(color: Colors.black.withOpacity(0.70)),
                ),
              ),
              const SizedBox(width: 10),
              if (row.showEdit)
                InkWell(
                  onTap: onEdit,
                  borderRadius: BorderRadius.circular(12),
                  child: const Padding(
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.edit_outlined),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

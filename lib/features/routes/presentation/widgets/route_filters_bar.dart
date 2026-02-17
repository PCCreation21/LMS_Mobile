import 'package:flutter/material.dart';
import '../../domain/route_models.dart';

class RouteFiltersBar extends StatelessWidget {
  const RouteFiltersBar({
    super.key,
    required this.searchBy,
    required this.onSearchByChanged,
    required this.queryController,
    required this.onApply,
    required this.applyEnabled,
  });

  final RouteSearchBy searchBy;
  final ValueChanged<RouteSearchBy> onSearchByChanged;

  final TextEditingController queryController;

  final VoidCallback onApply;
  final bool applyEnabled;

  String _label(RouteSearchBy v) {
    switch (v) {
      case RouteSearchBy.all:
        return "All";
      case RouteSearchBy.code:
        return "Route Code";
      case RouteSearchBy.name:
        return "Route Name";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text(
              "Search By:",
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.75),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black.withOpacity(0.12)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<RouteSearchBy>(
                    value: searchBy,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: RouteSearchBy.values
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text(_label(e)),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v != null) onSearchByChanged(v);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Search field
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.black.withOpacity(0.12)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: queryController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Route code, name...",
                  ),
                ),
              ),
              const Icon(Icons.search),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Apply Filter button with lines like your UI
        Row(
          children: [
            Expanded(child: Divider(color: Colors.black.withOpacity(0.10))),
            const SizedBox(width: 12),
            SizedBox(
              height: 42,
              width: 160,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD6A11E),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: applyEnabled ? onApply : null,
                child: const Text("Apply Filter"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Divider(color: Colors.black.withOpacity(0.10))),
          ],
        ),
      ],
    );
  }
}

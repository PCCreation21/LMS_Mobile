import 'package:flutter/material.dart';
import '../../domain/loan_management_models.dart';

class LoanFiltersBar extends StatelessWidget {
  const LoanFiltersBar({
    super.key,
    required this.status,
    required this.onStatusChanged,

    required this.routes,
    required this.selectedRoute,
    required this.onRouteChanged,

    required this.onAdvanceFilterTap,
    required this.onViewTap,
    required this.viewEnabled,
  });

  // Status
  final LoanStatus status;
  final ValueChanged<LoanStatus> onStatusChanged;

  // Routes
  /// Example: ["All Routes", "R001", "R002", "R003"]
  final List<String> routes;

  /// null or "All Routes" means no route filter
  final String? selectedRoute;

  final ValueChanged<String?> onRouteChanged;

  // Actions
  final VoidCallback onAdvanceFilterTap;
  final VoidCallback onViewTap;
  final bool viewEnabled;

  String _statusLabel(LoanStatus s) {
    switch (s) {
      case LoanStatus.all:
        return "All Status";
      case LoanStatus.open:
        return "Open";
      case LoanStatus.arrears:
        return "Arrears";
      case LoanStatus.completed:
        return "Completed";
      case LoanStatus.closed:
        return "Closed";
    }
  }

  String _routeLabel(String? r) {
    if (r == null || r.trim().isEmpty || r == "All Routes") return "All Routes";
    return r;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: Status + Routes
        Row(
          children: [
            Expanded(
              child: _PillDropdown(
                valueText: _statusLabel(status),
                onTap: () async {
                  final res = await showModalBottomSheet<LoanStatus>(
                    context: context,
                    showDragHandle: true,
                    builder: (ctx) => _StatusSheet(current: status),
                  );
                  if (res != null) onStatusChanged(res);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _PillDropdown(
                valueText: _routeLabel(selectedRoute),
                onTap: () async {
                  final res = await showModalBottomSheet<String?>(
                    context: context,
                    showDragHandle: true,
                    builder: (ctx) => _RouteSheet(
                      routes: routes,
                      current: _routeLabel(selectedRoute),
                    ),
                  );
                  // res can be null when user closes sheet
                  if (res != null) {
                    // If user picked "All Routes", treat it as null in state (clean)
                    onRouteChanged(res == "All Routes" ? null : res);
                  }
                },
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Row 2: Advance Filter (full width)
        Row(
          children: [
            Expanded(
              child: _PillButton(
                icon: Icons.filter_alt_outlined,
                text: "Advance Filter",
                onTap: onAdvanceFilterTap,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: 44,
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD6A11E),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: viewEnabled ? onViewTap : null,
                    child: const Text("View"),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PillDropdown extends StatelessWidget {
  const _PillDropdown({required this.valueText, required this.onTap});

  final String valueText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(valueText, overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  const _PillButton({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20),
            const SizedBox(width: 10),
            Expanded(child: Text(text, overflow: TextOverflow.ellipsis)),
          ],
        ),
      ),
    );
  }
}

class _StatusSheet extends StatelessWidget {
  const _StatusSheet({required this.current});
  final LoanStatus current;

  @override
  Widget build(BuildContext context) {
    Widget tile(LoanStatus s, String label) => ListTile(
      title: Text(label),
      trailing: s == current ? const Icon(Icons.check) : null,
      onTap: () => Navigator.pop(context, s),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile(LoanStatus.all, "All Status"),
        tile(LoanStatus.open, "Open"),
        tile(LoanStatus.arrears, "Arrears"),
        tile(LoanStatus.completed, "Completed"),
        tile(LoanStatus.closed, "Closed"),
        const SizedBox(height: 10),
      ],
    );
  }
}

class _RouteSheet extends StatelessWidget {
  const _RouteSheet({required this.routes, required this.current});

  final List<String> routes;
  final String current;

  @override
  Widget build(BuildContext context) {
    final list = routes.isEmpty ? const ["All Routes"] : routes;

    Widget tile(String label) => ListTile(
      title: Text(label),
      trailing: label == current ? const Icon(Icons.check) : null,
      onTap: () => Navigator.pop(context, label),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        tile("All Routes"),
        ...list.where((e) => e != "All Routes").map(tile),
        const SizedBox(height: 10),
      ],
    );
  }
}

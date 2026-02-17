import 'package:flutter/material.dart';

class RouteCollectionFiltersBar extends StatelessWidget {
  const RouteCollectionFiltersBar({
    super.key,
    required this.routeCodes,
    required this.officers,
    required this.routeValue,
    required this.officerValue,
    required this.fromText,
    required this.toText,
    required this.onRouteChanged,
    required this.onOfficerChanged,
    required this.onPickFrom,
    required this.onPickTo,
    required this.onApply,
    required this.onReset,
    required this.applyEnabled,
  });

  final List<String> routeCodes;
  final List<String> officers;

  final String routeValue; // "All" or actual
  final String officerValue; // "All" or actual

  final String fromText;
  final String toText;

  final ValueChanged<String> onRouteChanged;
  final ValueChanged<String> onOfficerChanged;

  final VoidCallback onPickFrom;
  final VoidCallback onPickTo;

  final VoidCallback onApply;
  final VoidCallback onReset;
  final bool applyEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Route Code",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _PillDropdown(
                    value: routeValue,
                    items: routeCodes,
                    onChanged: onRouteChanged,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Route Officer",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _PillDropdown(
                    value: officerValue,
                    items: officers,
                    onChanged: onOfficerChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "From:",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _DateBox(
                    value: fromText,
                    hint: "01/01/2026",
                    onTap: onPickFrom,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "To:",
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  _DateBox(value: toText, hint: "31/12/2026", onTap: onPickTo),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 14),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: applyEnabled ? onReset : null,
                child: const Text("Reset Filters"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(42),
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
          ],
        ),
      ],
    );
  }
}

class _PillDropdown extends StatelessWidget {
  const _PillDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.12)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({
    required this.value,
    required this.hint,
    required this.onTap,
  });

  final String value;
  final String hint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final showHint = value == hint;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.70),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: showHint
                      ? Colors.black.withOpacity(0.45)
                      : Colors.black,
                ),
              ),
            ),
            const Icon(Icons.calendar_month_outlined, size: 18),
          ],
        ),
      ),
    );
  }
}

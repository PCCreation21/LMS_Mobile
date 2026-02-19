import 'package:flutter/material.dart';
import '../../domain/loan_package_models.dart';

class LoanPackageFiltersBar extends StatelessWidget {
  const LoanPackageFiltersBar({
    super.key,
    required this.searchBy,
    required this.onSearchByChanged,
    required this.queryController,
    required this.onSearch,
    required this.searchEnabled,
  });

  final LoanPackageSearchBy searchBy;
  final ValueChanged<LoanPackageSearchBy> onSearchByChanged;

  final TextEditingController queryController;

  final VoidCallback onSearch;
  final bool searchEnabled;

  String _label(LoanPackageSearchBy v) {
    switch (v) {
      case LoanPackageSearchBy.all:
        return "All";
      case LoanPackageSearchBy.code:
        return "Package Code";
      case LoanPackageSearchBy.name:
        return "Package Name";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search By row
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
                  child: DropdownButton<LoanPackageSearchBy>(
                    value: searchBy,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: LoanPackageSearchBy.values
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

        // Search input
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
                    hintText: "Package code, name...",
                  ),
                ),
              ),
              const Icon(Icons.search),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Search button with side dividers
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
                onPressed: searchEnabled ? onSearch : null,
                child: const Text("Search"),
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

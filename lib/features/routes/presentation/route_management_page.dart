import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/route_controller.dart';
import 'widgets/route_filters_bar.dart';
import 'widgets/route_card.dart';
import 'widgets/route_table.dart';

class RouteManagementPage extends ConsumerStatefulWidget {
  const RouteManagementPage({super.key});

  @override
  ConsumerState<RouteManagementPage> createState() =>
      _RouteManagementPageState();
}

class _RouteManagementPageState extends ConsumerState<RouteManagementPage> {
  late final TextEditingController _queryCtrl;

  @override
  void initState() {
    super.initState();
    _queryCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(routeProvider);
    final controller = ref.read(routeProvider.notifier);

    // Keep controller state in sync with textfield (only update on Apply)
    // But we still set text here if state changes (optional).
    if (_queryCtrl.text != state.filters.query) {
      _queryCtrl.text = state.filters.query;
      _queryCtrl.selection = TextSelection.fromPosition(
        TextPosition(offset: _queryCtrl.text.length),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/onboarding_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth >= 900;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      // Green header like your screenshot
                      Container(
                        height: 54,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2F5F52).withOpacity(0.92),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                            ),
                            const Expanded(
                              child: Text(
                                "Route Management",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w800,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                // TODO: open create route page
                              },
                              icon: const Icon(Icons.add, color: Colors.white),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.78),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.55),
                          ),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Route Management",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Define and manage collection routes",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),

                            const SizedBox(height: 14),

                            RouteFiltersBar(
                              searchBy: state.filters.searchBy,
                              onSearchByChanged: controller.setSearchBy,
                              queryController: _queryCtrl,
                              onApply: () {
                                controller.setQuery(_queryCtrl.text);
                                controller.applyFilter();
                              },
                              applyEnabled: !state.loading,
                            ),

                            const SizedBox(height: 16),

                            if (state.loading)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 30),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (state.error != null)
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Center(
                                  child: Text("Error loading routes"),
                                ),
                              )
                            else if (state.rows.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 24,
                                ),
                                child: Column(
                                  children: [
                                    const Text(
                                      "No Routes Found",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Try adjusting your filters.",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              isDesktop
                                  ? RouteTable(
                                      rows: state.rows,
                                      onEdit: (r) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Edit ${r.routeCode}",
                                            ),
                                          ),
                                        );
                                      },
                                      onDelete: (r) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              "Delete ${r.routeCode}",
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Column(
                                      children: state.rows
                                          .map(
                                            (r) => RouteCard(
                                              row: r,
                                              onEdit: () {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      "Edit ${r.routeCode}",
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          .toList(),
                                    ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

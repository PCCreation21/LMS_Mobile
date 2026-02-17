import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../state/route_collection_controller.dart';
import 'widgets/route_collection_filters.dart';
import 'widgets/route_collection_card.dart';
import 'widgets/route_collection_table.dart';

class RouteCollectionTrackingPage extends ConsumerWidget {
  const RouteCollectionTrackingPage({super.key});

  String _fmtFilterDate(DateTime? d, {required String fallback}) {
    if (d == null) return fallback;
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return "$dd/$mm/${d.year}";
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(routeCollectionProvider);
    final controller = ref.read(routeCollectionProvider.notifier);

    Future<void> pickFrom() async {
      final now = DateTime.now();
      final d = await showDatePicker(
        context: context,
        firstDate: DateTime(now.year - 10),
        lastDate: DateTime(now.year + 10),
        initialDate: state.filters.from ?? now,
      );
      if (d != null) controller.setFrom(d);
    }

    Future<void> pickTo() async {
      final now = DateTime.now();
      final d = await showDatePicker(
        context: context,
        firstDate: DateTime(now.year - 10),
        lastDate: DateTime(now.year + 10),
        initialDate: state.filters.to ?? now,
      );
      if (d != null) controller.setTo(d);
    }

    final routeDropdownValue = state.filters.routeCode ?? "All";
    final officerDropdownValue = state.filters.officer ?? "All";

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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _HeaderBar(onBack: () => context.pop()),

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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Route Collection Tracking",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              "Monitor retal collections by route and officer",
                              style: TextStyle(
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ),
                            const SizedBox(height: 14),
                            RouteCollectionFiltersBar(
                              routeCodes: state.routeCodes,
                              officers: state.officers,
                              routeValue: routeDropdownValue,
                              officerValue: officerDropdownValue,
                              fromText: _fmtFilterDate(
                                state.filters.from,
                                fallback: "From",
                              ),
                              toText: _fmtFilterDate(
                                state.filters.to,
                                fallback: "To",
                              ),
                              onRouteChanged: controller.setRouteCode,
                              onOfficerChanged: controller.setOfficer,
                              onPickFrom: pickFrom,
                              onPickTo: pickTo,
                              onApply: controller.applyFilter,
                              onReset: controller.resetFilters,
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
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: Text("Error loading records"),
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
                                      "No Collection Records Found",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Adjust filters to view route collections.",
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else
                              isDesktop
                                  ? RouteCollectionTable(rows: state.rows)
                                  : Column(
                                      children: state.rows
                                          .map(
                                            (r) => RouteCollectionCard(row: r),
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
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == 0) context.go('/home');
          if (index == 1) context.go('/customers');
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Customers"),
          BottomNavigationBarItem(icon: Icon(Icons.payment), label: "Payments"),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: "More"),
        ],
      ),
    );
  }
}

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const Spacer(),
          Row(
            children: [
              Image.asset('assets/images/logo.png', height: 26),
              const SizedBox(width: 10),
              const Text(
                "GOLDEN CASH",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
          const Spacer(),
          const CircleAvatar(radius: 18, backgroundColor: Colors.white24),
        ],
      ),
    );
  }
}

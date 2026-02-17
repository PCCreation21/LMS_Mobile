import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';

import '../state/loan_management_controller.dart';

import 'widgets/advance_filter_side_sheet.dart';
import 'widgets/loan_filters_bar.dart';
import 'package:loan_management_system/features/loan/presentation/widgets/loan_table.dart';

class LoanManagementPage extends ConsumerStatefulWidget {
  const LoanManagementPage({super.key});

  @override
  ConsumerState<LoanManagementPage> createState() => _LoanManagementPageState();
}

class _LoanManagementPageState extends ConsumerState<LoanManagementPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loanManagementProvider);
    final controller = ref.read(loanManagementProvider.notifier);

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
            child: Column(
              children: [
                _HeaderBar(onBack: () => context.pop()),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.78),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.55)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Loan Management",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "View and manage all loans in the system",
                      style: TextStyle(color: Colors.black.withOpacity(0.6)),
                    ),
                    const SizedBox(height: 14),

                    /// ✅ Filters Bar: Status + Routes + Advanced Filter + View button
                    LoanFiltersBar(
                      status: state.status,
                      onStatusChanged: controller.setStatus,

                      // ✅ Routes support
                      routes: state.routes, // e.g. ["All Routes","R001","R002"]
                      selectedRoute:
                          state.selectedRoute, // null means All Routes
                      onRouteChanged: controller.setRoute,

                      // ✅ Side filter like screenshot
                      onAdvanceFilterTap: () async {
                        final res = await showAdvanceFilterSideSheet(
                          context: context,
                          initial: state.filters,
                        );

                        if (res != null) {
                          controller.applyFilters(res);

                          // Optional:
                          // If you want to refresh immediately after Save, uncomment:
                          await controller.load();
                        }
                      },

                      // ✅ "View" applies selected status + route + filters
                      onViewTap: controller.load,
                      viewEnabled: !state.loading,
                    ),

                    const SizedBox(height: 16),

                    if (state.loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (state.error != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(child: Text("Error")),
                      )
                    else
                      LoanTable(
                        rows: state.rows,
                        onRowTap: (row) {
                          context.push('/loans/${row.loanId}');
                        },
                      ),
                  ],
                ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
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

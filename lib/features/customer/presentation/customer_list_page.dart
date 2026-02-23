import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/widgets/app_bottom_nav.dart';
import '../../../app/widgets/app_header_bar.dart';
import '../../../app/widgets/glass_card.dart';
import '../domain/customer_models.dart';
import '../state/customer_list_controller.dart';
import 'widgets/customer_row_card.dart';

class CustomerListPage extends ConsumerStatefulWidget {
  const CustomerListPage({super.key});

  @override
  ConsumerState<CustomerListPage> createState() => _CustomerListPageState();
}

class _CustomerListPageState extends ConsumerState<CustomerListPage> {
  final _searchCtrl = TextEditingController();

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerListProvider);
    final controller = ref.read(customerListProvider.notifier);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/onboarding_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.05)),

          SafeArea(
            child: Column(
              children: [
                AppHeaderBar(onBack: () => context.pop()),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    child: GlassCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Customer Management",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text("View and manage customer accounts"),
                          const SizedBox(height: 16),

                          // Search By dropdown
                          Row(
                            children: [
                              const Text(
                                "Search By:",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child:
                                    DropdownButtonFormField<CustomerSearchBy>(
                                      value: state.searchBy,
                                      items: const [
                                        DropdownMenuItem(
                                          value: CustomerSearchBy.all,
                                          child: Text("All"),
                                        ),
                                        DropdownMenuItem(
                                          value: CustomerSearchBy.nic,
                                          child: Text("NIC"),
                                        ),
                                        DropdownMenuItem(
                                          value: CustomerSearchBy.name,
                                          child: Text("Customer Name"),
                                        ),
                                        DropdownMenuItem(
                                          value: CustomerSearchBy.phone,
                                          child: Text("Phone Number"),
                                        ),
                                      ],
                                      onChanged: (v) {
                                        if (v != null)
                                          controller.setSearchBy(v);
                                      },
                                    ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Search field + button
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _searchCtrl,
                                  onChanged: controller.setQuery,
                                  decoration: const InputDecoration(
                                    hintText: "NIC, name, or phone...",
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFC8922D),
                                  ),
                                  onPressed: state.isLoading
                                      ? null
                                      : controller.applySearch,
                                  child: const Text("Search"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          Expanded(
                            child: Builder(
                              builder: (_) {
                                if (state.isLoading && state.all.isEmpty) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                if (state.filtered.isEmpty) {
                                  return const Center(
                                    child: Text("No Records Found"),
                                  );
                                }

                                return ListView.builder(
                                  itemCount: state.filtered.length,
                                  itemBuilder: (context, i) {
                                    final c = state.filtered[i];
                                    return CustomerRowCard(
                                      customer: c,
                                      onTapNic: () {
                                        context.push('/customers/${c.id}');
                                      },
                                      onEdit: () {
                                        context.push(
                                          '/customers/${c.id}/update',
                                        );
                                      },
                                      onDelete: () async {
                                        final yes = await _confirmDelete(
                                          context,
                                          c.name,
                                        );
                                        if (yes != true) return;

                                        final ok = await controller
                                            .deleteCustomer(c.id);
                                        if (!context.mounted) return;

                                        if (!ok) {
                                          final err =
                                              ref
                                                  .read(customerListProvider)
                                                  .error ??
                                              "Delete failed";
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(content: Text(err)),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Customer deleted"),
                                            ),
                                          );
                                        }
                                      },
                                    );
                                  },
                                );
                              },
                            ),
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
      bottomNavigationBar: const AppBottomNav(
        currentIndex: 1,
        pageName: "Customer",
      ),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context, String name) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Customer"),
        content: Text("Are you sure you want to delete $name?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }
}

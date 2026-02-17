import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

import '../../../core/utils/validators.dart';
import '../domain/customer_models.dart';
import '../state/customer_list_controller.dart';

class UpdateCustomerPage extends ConsumerStatefulWidget {
  const UpdateCustomerPage({super.key, required this.id});
  final String id;

  @override
  ConsumerState<UpdateCustomerPage> createState() => _UpdateCustomerPageState();
}

class _UpdateCustomerPageState extends ConsumerState<UpdateCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  final _nicCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _secPhoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String? _routeCode;

  bool _initialized = false;

  @override
  void dispose() {
    _nicCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _secPhoneCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  void _initFromCustomer(Customer c) {
    _nicCtrl.text = c.nic;
    _nameCtrl.text = c.name;
    _phoneCtrl.text = c.phone;
    _secPhoneCtrl.text = c.secondaryPhone ?? "";
    _addressCtrl.text = c.address;
    _emailCtrl.text = c.email ?? "";
    _routeCode = c.routeCode;
    _initialized = true;
  }

  Future<void> _onUpdate(Customer original) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final controller = ref.read(customerListProvider.notifier);

    // ✅ NIC uniqueness check (only if NIC changed)
    final newNic = _nicCtrl.text.trim();
    if (newNic.toLowerCase() != original.nic.trim().toLowerCase()) {
      final unique = controller.isNicUnique(
        newNic,
        excludeCustomerId: original.id,
      );
      if (!unique) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("NIC already exists. Please use a unique NIC."),
          ),
        );
        return;
      }
    }

    final updated = original.copyWith(
      nic: _nicCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      secondaryPhone: _secPhoneCtrl.text.trim().isEmpty
          ? null
          : _secPhoneCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      routeCode: _routeCode!,
      // status NOT editable here (per spec)
      // createdDate NOT editable
      // loanNumbers NOT editable
    );

    final ok = await controller.updateCustomer(updated);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer updated successfully")),
      );
      context.pop();
    } else {
      final err = ref.read(customerListProvider).error ?? "Update failed";
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerListProvider);
    final controller = ref.read(customerListProvider.notifier);

    final customer = state.all.firstWhere((c) => c.id == widget.id);

    if (!_initialized) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _initFromCustomer(customer));
      });
    }

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('assets/images/onboarding_bg.png', fit: BoxFit.cover),
          Container(color: Colors.black.withOpacity(0.05)),

          SafeArea(
            child: Column(
              children: [
                _HeaderBar(onBack: () => context.pop()),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                    child: _GlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Update Customer",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text("View and manage customer accounts"),
                            const SizedBox(height: 18),

                            _Field(
                              label: "NIC",
                              child: TextFormField(
                                controller: _nicCtrl,
                                validator: Validators.nic,
                                decoration: const InputDecoration(
                                  hintText: "NIC",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            _Field(
                              label: "Customer Name *",
                              child: TextFormField(
                                controller: _nameCtrl,
                                validator: (v) => Validators.requiredField(
                                  v,
                                  name: "Customer Name",
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Customer name",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            _Field(
                              label: "Phone Number *",
                              child: TextFormField(
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                validator: Validators.phoneLK,
                                decoration: const InputDecoration(
                                  hintText: "+94 7X XXX XXXX",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            _Field(
                              label: "Secondary Phone",
                              child: TextFormField(
                                controller: _secPhoneCtrl,
                                keyboardType: TextInputType.phone,
                                validator: (v) {
                                  final val = (v ?? "").trim();
                                  if (val.isEmpty) return null;
                                  return Validators.phoneLK(val);
                                },
                                decoration: const InputDecoration(
                                  hintText: "Optional",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            _Field(
                              label: "Address *",
                              child: TextFormField(
                                controller: _addressCtrl,
                                validator: (v) => Validators.requiredField(
                                  v,
                                  name: "Address",
                                ),
                                decoration: const InputDecoration(
                                  hintText: "Address",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            _Field(
                              label: "Email",
                              child: TextFormField(
                                controller: _emailCtrl,
                                keyboardType: TextInputType.emailAddress,
                                validator: Validators.emailOptional,
                                decoration: const InputDecoration(
                                  hintText: "example@email.com",
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),

                            _Field(
                              label: "Route Code *",
                              child: DropdownButtonFormField<String>(
                                value: _routeCode,
                                items: const [
                                  DropdownMenuItem(
                                    value: "R001",
                                    child: Text("R001"),
                                  ),
                                  DropdownMenuItem(
                                    value: "R002",
                                    child: Text("R002"),
                                  ),
                                  DropdownMenuItem(
                                    value: "R003",
                                    child: Text("R003"),
                                  ),
                                  DropdownMenuItem(
                                    value: "R004",
                                    child: Text("R004"),
                                  ),
                                ],
                                onChanged: (v) =>
                                    setState(() => _routeCode = v),
                                validator: (v) => (v == null || v.isEmpty)
                                    ? "Route Code is required"
                                    : null,
                              ),
                            ),

                            const SizedBox(height: 18),

                            // ✅ Buttons (Cancel + Update)
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: state.isLoading
                                        ? null
                                        : () => context.pop(),
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text("Cancel"),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: state.isLoading
                                        ? null
                                        : () => _onUpdate(customer),
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                      backgroundColor: const Color(0xFFC8922D),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: state.isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            "Update Customer",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.90),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.child});
  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

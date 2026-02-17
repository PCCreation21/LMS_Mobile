import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';

import '../../../app/widgets/app_dropdown_field.dart';
import '../../../core/utils/validators.dart';
import '../domain/customer_models.dart';
import '../state/create_customer_controller.dart';

class CreateCustomerPage extends ConsumerStatefulWidget {
  const CreateCustomerPage({super.key});

  @override
  ConsumerState<CreateCustomerPage> createState() => _CreateCustomerPageState();
}

class _CreateCustomerPageState extends ConsumerState<CreateCustomerPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _nicCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _secondaryPhoneCtrl = TextEditingController();

  final _addressLine1Ctrl = TextEditingController(); // "Line 1"
  final _street1Ctrl = TextEditingController(); // "Street address"
  final _street2Ctrl = TextEditingController();
  final _street3Ctrl = TextEditingController();

  final _emailCtrl = TextEditingController();

  Gender? _gender;
  CustomerStatus? _status;
  String? _routeCode;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nicCtrl.dispose();
    _phoneCtrl.dispose();
    _secondaryPhoneCtrl.dispose();
    _addressLine1Ctrl.dispose();
    _street1Ctrl.dispose();
    _street2Ctrl.dispose();
    _street3Ctrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  bool get _isSmall => MediaQuery.sizeOf(context).width < 380;

  Future<void> _submit() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final req = CreateCustomerRequest(
      name: _nameCtrl.text.trim(),
      nic: _nicCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      secondaryPhone: _secondaryPhoneCtrl.text.trim().isEmpty
          ? null
          : _secondaryPhoneCtrl.text.trim(),
      addressLine1: _addressLine1Ctrl.text.trim(),
      street1: _street1Ctrl.text.trim(),
      street2: _street2Ctrl.text.trim().isEmpty
          ? null
          : _street2Ctrl.text.trim(),
      street3: _street3Ctrl.text.trim().isEmpty
          ? null
          : _street3Ctrl.text.trim(),
      email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
      gender: _gender!,
      status: _status!,
      routeCode: _routeCode!,
    );

    final ok = await ref
        .read(createCustomerControllerProvider.notifier)
        .submit(req);

    if (!mounted) return;

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Customer created successfully")),
      );
      context.pop(); // go back
    } else {
      final err = ref.read(createCustomerControllerProvider).error;
      if (err != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(err)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createCustomerControllerProvider);

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
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: _GlassCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            const Text(
                              "Create Customer",
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF2F4A3D),
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              "Register a new customer",
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF5B6B63),
                              ),
                            ),
                            const SizedBox(height: 18),

                            // Customer Name
                            _LabeledTextField(
                              label: "Customer Name *",
                              hint: "Enter full name",
                              controller: _nameCtrl,
                              validator: (v) => Validators.requiredField(
                                v,
                                name: "Customer Name",
                              ),
                            ),
                            const SizedBox(height: 14),

                            // NIC + Phone (2 cols)
                            _ResponsiveRow(
                              isSmall: _isSmall,
                              left: _LabeledTextField(
                                label: "NIC *",
                                hint: "XXXXXXXXXV / XXXXXXXXXXXX",
                                controller: _nicCtrl,
                                validator: Validators.nic,
                              ),
                              right: _LabeledTextField(
                                label: "Phone Number *",
                                hint: "+94 XX XXX XXXX",
                                controller: _phoneCtrl,
                                keyboardType: TextInputType.phone,
                                validator: Validators.phoneLK,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Address line 1 + Secondary phone
                            _ResponsiveRow(
                              isSmall: _isSmall,
                              left: AppDropdownField<Gender>(
                                label: "Gender *",
                                value: _gender,
                                hintText: "Select Gender",
                                items: const [
                                  DropdownMenuItem(
                                    value: Gender.male,
                                    child: Text("Male"),
                                  ),
                                  DropdownMenuItem(
                                    value: Gender.female,
                                    child: Text("Female"),
                                  ),
                                  DropdownMenuItem(
                                    value: Gender.other,
                                    child: Text("Other"),
                                  ),
                                ],
                                onChanged: (v) => setState(() => _gender = v),
                                validator: (v) =>
                                    v == null ? "Gender is required" : null,
                              ),
                              right: _LabeledTextField(
                                label: "Secondary Phone No.",
                                hint: "Optional",
                                controller: _secondaryPhoneCtrl,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Street address lines (full width like design)
                            _LabeledTextField(
                              label: "Address *",
                              hint: "Street address",
                              controller: _street1Ctrl,
                              validator: (v) => Validators.requiredField(
                                v,
                                name: "Street address",
                              ),
                            ),
                            const SizedBox(height: 10),
                            _LabeledTextField(
                              label: "",
                              hint: "Street address line 2",
                              controller: _street2Ctrl,
                            ),
                            const SizedBox(height: 10),
                            _LabeledTextField(
                              label: "",
                              hint: "Street address line 3",
                              controller: _street3Ctrl,
                            ),

                            const SizedBox(height: 14),

                            _LabeledTextField(
                              label: "Email",
                              hint: "example@email.com",
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              validator: Validators.emailOptional,
                            ),

                            const SizedBox(height: 14),

                            // Gender + Status
                            _ResponsiveRow(
                              isSmall: _isSmall,
                              left: AppDropdownField<String>(
                                label: "Route Code *",
                                value: _routeCode,
                                hintText: "Select Code",
                                items: state.routes
                                    .map(
                                      (r) => DropdownMenuItem(
                                        value: r.code,
                                        child: Text("${r.code} - ${r.name}"),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (v) =>
                                    setState(() => _routeCode = v),
                                validator: (v) =>
                                    v == null ? "Route Code is required" : null,
                              ),
                              right: AppDropdownField<CustomerStatus>(
                                label: "Status",
                                value: _status,
                                hintText: "Select Status",
                                items: const [
                                  DropdownMenuItem(
                                    value: CustomerStatus.active,
                                    child: Text("Active"),
                                  ),
                                  DropdownMenuItem(
                                    value: CustomerStatus.inactive,
                                    child: Text("Inactive"),
                                  ),
                                ],
                                onChanged: (v) => setState(() => _status = v),
                                validator: (v) =>
                                    v == null ? "Status is required" : null,
                              ),
                            ),

                            const SizedBox(height: 28),

                            // Bottom buttons
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
                                    onPressed: state.isLoading ? null : _submit,
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size.fromHeight(48),
                                      backgroundColor: const Color(
                                        0xFFC8922D,
                                      ), // gold button like design
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: state.isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            "Create Customer",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w700,
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

class _ResponsiveRow extends StatelessWidget {
  const _ResponsiveRow({
    required this.isSmall,
    required this.left,
    required this.right,
  });

  final bool isSmall;
  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    if (isSmall) {
      return Column(children: [left, const SizedBox(height: 14), right]);
    }
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }
}

class _LabeledTextField extends StatelessWidget {
  const _LabeledTextField({
    required this.label,
    required this.hint,
    required this.controller,
    this.validator,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

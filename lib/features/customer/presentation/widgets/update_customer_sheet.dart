import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/customer_models.dart';
import '../../state/customer_list_controller.dart';

class UpdateCustomerSheet extends ConsumerStatefulWidget {
  const UpdateCustomerSheet({super.key, required this.customer});
  final Customer customer;

  @override
  ConsumerState<UpdateCustomerSheet> createState() =>
      _UpdateCustomerSheetState();
}

class _UpdateCustomerSheetState extends ConsumerState<UpdateCustomerSheet> {
  final _formKey = GlobalKey<FormState>();

  late final _nic = TextEditingController(text: widget.customer.nic);
  late final _name = TextEditingController(text: widget.customer.name);
  late final _phone = TextEditingController(text: widget.customer.phone);
  late final _secPhone = TextEditingController(
    text: widget.customer.secondaryPhone ?? "",
  );
  late final _address = TextEditingController(text: widget.customer.address);
  late final _email = TextEditingController(text: widget.customer.email ?? "");
  late String _routeCode = widget.customer.routeCode;

  @override
  void dispose() {
    _nic.dispose();
    _name.dispose();
    _phone.dispose();
    _secPhone.dispose();
    _address.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(customerListProvider);
    final controller = ref.read(customerListProvider.notifier);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: const BoxDecoration(color: Colors.transparent),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Update Customer",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: state.isLoading
                              ? null
                              : () => Navigator.pop(context),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Editable fields
                    TextFormField(
                      controller: _nic,
                      decoration: const InputDecoration(
                        labelText: "NIC (editable if required)",
                      ),
                      validator: (v) {
                        final base = Validators.nic(v);
                        if (base != null) return base;
                        final ok = controller.isNicUnique(
                          v!.trim(),
                          excludeCustomerId: widget.customer.id,
                        );
                        if (!ok) return "NIC already exists";
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _name,
                      decoration: const InputDecoration(
                        labelText: "Customer Name *",
                      ),
                      validator: (v) =>
                          Validators.requiredField(v, name: "Customer Name"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _phone,
                      decoration: const InputDecoration(
                        labelText: "Phone Number *",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: Validators.phoneLK,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _secPhone,
                      decoration: const InputDecoration(
                        labelText: "Secondary Phone (optional)",
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        final val = (v ?? "").trim();
                        if (val.isEmpty) return null;
                        return Validators.phoneLK(val);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _address,
                      decoration: const InputDecoration(labelText: "Address *"),
                      validator: (v) =>
                          Validators.requiredField(v, name: "Address"),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                        labelText: "Email (optional)",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: Validators.emailOptional,
                    ),
                    const SizedBox(height: 10),

                    DropdownButtonFormField<String>(
                      value: _routeCode,
                      decoration: const InputDecoration(
                        labelText: "Route Code *",
                      ),
                      items: const [
                        DropdownMenuItem(value: "R001", child: Text("R001")),
                        DropdownMenuItem(value: "R002", child: Text("R002")),
                        DropdownMenuItem(value: "R003", child: Text("R003")),
                        DropdownMenuItem(value: "R004", child: Text("R004")),
                      ],
                      onChanged: (v) =>
                          setState(() => _routeCode = v ?? _routeCode),
                      validator: (v) => (v == null || v.isEmpty)
                          ? "Route Code is required"
                          : null,
                    ),

                    const SizedBox(height: 14),

                    // Read-only fields
                    TextFormField(
                      readOnly: true,
                      initialValue: widget.customer.createdDate
                          .toIso8601String()
                          .split("T")
                          .first,
                      decoration: const InputDecoration(
                        labelText: "Created Date (read-only)",
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      readOnly: true,
                      initialValue: widget.customer.loanNumbers.isEmpty
                          ? "-"
                          : widget.customer.loanNumbers.join(", "),
                      decoration: const InputDecoration(
                        labelText: "Loan Numbers (read-only)",
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: state.isLoading
                                ? null
                                : () => Navigator.pop(context),
                            child: const Text("Cancel"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFC8922D),
                            ),
                            onPressed: state.isLoading
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate())
                                      return;

                                    final updated = widget.customer.copyWith(
                                      nic: _nic.text.trim(),
                                      name: _name.text.trim(),
                                      phone: _phone.text.trim(),
                                      secondaryPhone:
                                          _secPhone.text.trim().isEmpty
                                          ? null
                                          : _secPhone.text.trim(),
                                      address: _address.text.trim(),
                                      email: _email.text.trim().isEmpty
                                          ? null
                                          : _email.text.trim(),
                                      routeCode: _routeCode,
                                      // status is not editable here (per spec)
                                    );

                                    final ok = await controller.updateCustomer(
                                      updated,
                                    );

                                    if (!context.mounted) return;

                                    if (ok) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text("Customer updated"),
                                        ),
                                      );
                                    } else {
                                      final err =
                                          ref
                                              .read(customerListProvider)
                                              .error ??
                                          "Update failed";
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text(err)),
                                      );
                                    }
                                  },
                            child: state.isLoading
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text("Update"),
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
      ),
    );
  }
}

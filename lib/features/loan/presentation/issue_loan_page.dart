import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/app_dropdown_field.dart';
import '../../../app/widgets/app_text_field.dart';
import '../../../core/utils/validators.dart';
import '../domain/loan_models.dart';
import '../state/issue_loan_controller.dart';

class IssueLoanPage extends ConsumerStatefulWidget {
  const IssueLoanPage({super.key});

  @override
  ConsumerState<IssueLoanPage> createState() => _IssueLoanPageState();
}

class _IssueLoanPageState extends ConsumerState<IssueLoanPage> {
  final _formKey = GlobalKey<FormState>();

  final _nicCtrl = TextEditingController();
  final _customerNameCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();

  int _currentIndex = 0;

  @override
  void dispose() {
    _nicCtrl.dispose();
    _customerNameCtrl.dispose();
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate(IssueLoanController controller) async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 10),
      initialDate: now,
    );

    if (selected != null) controller.setStartDate(selected);
  }

  String _fmtDate(DateTime? d) {
    if (d == null) return "dd/mm/yyyy";
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    final yyyy = d.year.toString();
    return "$dd/$mm/$yyyy";
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(issueLoanControllerProvider);
    final controller = ref.read(issueLoanControllerProvider.notifier);

    // keep readonly name in sync
    _customerNameCtrl.text = state.customerName;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top header (logo + user)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "GOLDEN CASH",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage: AssetImage(
                              'assets/images/logo.png',
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            "John Doe",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Breadcrumb
                  Row(
                    children: const [
                      Icon(Icons.home_outlined, size: 18),
                      SizedBox(width: 6),
                      Text("Dashboard"),
                      SizedBox(width: 6),
                      Icon(Icons.chevron_right, size: 18),
                      SizedBox(width: 6),
                      Text(
                        "Loans",
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Main card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Issue Loan",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text("Create a new loan for a customer"),
                          const SizedBox(height: 16),

                          // NIC + search
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: "NIC*",
                                  hint: "Enter Customer NIC Number",
                                  controller: _nicCtrl,
                                  validator: Validators.nic,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 2),
                                child: InkWell(
                                  onTap: state.isLoading
                                      ? null
                                      : () async {
                                          if (Validators.nic(_nicCtrl.text) !=
                                              null) {
                                            _formKey.currentState?.validate();
                                            return;
                                          }
                                          await controller.searchCustomerByNic(
                                            _nicCtrl.text,
                                          );
                                        },
                                  borderRadius: BorderRadius.circular(30),
                                  child: Container(
                                    width: 54,
                                    height: 54,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                      border: Border.all(
                                        color: Colors.black.withOpacity(0.15),
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.06),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: state.isLoading
                                        ? const Padding(
                                            padding: EdgeInsets.all(14),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(
                                            Icons.search,
                                            color: Color(0xFFF59E0B),
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Customer Name (readonly)
                          AppTextField(
                            label: "Customer Name *",
                            hint: "Customer name will appear here",
                            controller: _customerNameCtrl,
                            readOnly: true,
                            validator: (v) {
                              if ((v ?? '').trim().isEmpty) {
                                return "Search NIC to load customer";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Amount
                          AppTextField(
                            label: "Loan Amount (LKR) *",
                            hint: "Enter Loan Amount",
                            controller: _amountCtrl,
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              final val = (v ?? '').trim();
                              if (val.isEmpty) return "Loan amount is required";
                              final numVal = double.tryParse(
                                val.replaceAll(',', ''),
                              );
                              if (numVal == null || numVal <= 0)
                                return "Enter a valid amount";
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Package
                          AppDropdownField<LoanPackageLite>(
                            label: "Loan Package *",
                            value: state.selectedPackage,
                            hintText: "Select Loan Package",
                            items: state.packages
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p,
                                    child: Text(p.name),
                                  ),
                                )
                                .toList(),
                            onChanged: controller.selectPackage,
                            validator: (v) =>
                                v == null ? "Loan package is required" : null,
                          ),

                          const SizedBox(height: 12),

                          // Dates row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Start Date*",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 56,
                                      child: InkWell(
                                        onTap: () => _pickStartDate(controller),
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            border: Border.all(
                                              color: Colors.black.withOpacity(
                                                0.15,
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                _fmtDate(state.startDate),
                                                style: TextStyle(
                                                  color: state.startDate == null
                                                      ? Colors.black
                                                            .withOpacity(0.45)
                                                      : Colors.black,
                                                ),
                                              ),
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "End Date",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      height: 56,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          border: Border.all(
                                            color: Colors.black.withOpacity(
                                              0.15,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          _fmtDate(state.endDate),
                                          style: TextStyle(
                                            color: state.endDate == null
                                                ? Colors.black.withOpacity(0.45)
                                                : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      "Automatically calculated\nbased on package.",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          if (state.error != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              state.error!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],

                          const SizedBox(height: 18),

                          // Buttons
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
                                      : () async {
                                          final ok =
                                              _formKey.currentState
                                                  ?.validate() ??
                                              false;
                                          if (!ok) return;

                                          if (state.selectedPackage == null ||
                                              state.startDate == null ||
                                              state.endDate == null) {
                                            return;
                                          }

                                          final amount = double.parse(
                                            _amountCtrl.text.trim().replaceAll(
                                              ',',
                                              '',
                                            ),
                                          );

                                          final success = await controller
                                              .issueLoan(
                                                nic: _nicCtrl.text.trim(),
                                                amount: amount,
                                                pkg: state.selectedPackage!,
                                                startDate: state.startDate!,
                                                endDate: state.endDate!,
                                              );

                                          if (!mounted) return;

                                          if (success) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Loan issued successfully",
                                                ),
                                              ),
                                            );
                                            context.pop();
                                          }
                                        },
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
                                          width: 22,
                                          height: 22,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.4,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "Issue Loan",
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
                ],
              ),
            ),
          ),
        ],
      ),

      // Bottom Navigation (same pattern as your HomePage)
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          if (index == 0) {
            context.go('/home');
          } else if (index == 1) {
            context.push('/customers');
          }
          // TODO: add routes for payments/more when you implement them
        },
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    this.onTap,
    this.helperText,
    this.errorText,
  });

  final String label;
  final String value;
  final VoidCallback? onTap;
  final String? helperText;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              suffixIcon: enabled ? const Icon(Icons.calendar_month) : null,
              errorText: errorText,
              helperText: helperText,
              helperMaxLines: 2,
            ),
            child: Text(
              value,
              style: TextStyle(
                color: value == "dd/mm/yyyy"
                    ? Colors.black.withOpacity(0.45)
                    : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

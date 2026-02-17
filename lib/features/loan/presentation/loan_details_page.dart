import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';

import '../state/loan_details_controller.dart';
import '../domain/loan_details_models.dart';
import 'widgets/payment_history_table.dart';

class LoanDetailsPage extends ConsumerWidget {
  const LoanDetailsPage({super.key, required this.loanId});
  final String loanId;

  String _money(double v) => "LKR ${v.toStringAsFixed(0)}";

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return "$dd/$mm/${d.year}";
  }

  Widget _statusChip(LoanStatus s) {
    String t;
    Color bg;
    Color fg;

    switch (s) {
      case LoanStatus.open:
        t = "Open";
        bg = const Color(0xFFDDE7E2);
        fg = const Color(0xFF1F5B49);
        break;
      case LoanStatus.arrears:
        t = "Arrears";
        bg = const Color(0xFFFFE0E0);
        fg = const Color(0xFFD12B2B);
        break;
      case LoanStatus.completed:
        t = "Completed";
        bg = const Color(0xFFEADDCB);
        fg = Colors.black.withOpacity(0.55);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        t,
        style: TextStyle(fontWeight: FontWeight.w800, color: fg),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loanDetailsProvider(loanId));

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
                    child: state.loading
                        ? const Padding(
                            padding: EdgeInsets.only(top: 60),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : state.error != null
                        ? Padding(
                            padding: const EdgeInsets.only(top: 60),
                            child: Center(child: Text(state.error!)),
                          )
                        : _Body(
                            data: state.data!,
                            money: _money,
                            fmtDate: _fmtDate,
                            statusChip: _statusChip,
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

class _Body extends StatelessWidget {
  const _Body({
    required this.data,
    required this.money,
    required this.fmtDate,
    required this.statusChip,
  });

  final LoanDetailsModel data;
  final String Function(double) money;
  final String Function(DateTime) fmtDate;
  final Widget Function(LoanStatus) statusChip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title + status
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Loan Details",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
            ),
            statusChip(data.status),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          "Viewing history for loan: ${data.loanId}",
          style: TextStyle(color: Colors.black.withOpacity(0.60)),
        ),
        const SizedBox(height: 14),

        // Main detail card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.78),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.white.withOpacity(0.55)),
          ),
          child: Column(
            children: [
              // Customer block
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      data.customer.avatarAsset ??
                          'assets/images/sample_user.png',
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.customer.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text("NIC: ${data.customer.nic}"),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.call_outlined,
                              size: 16,
                              color: Colors.black.withOpacity(0.55),
                            ),
                            const SizedBox(width: 6),
                            Text(data.customer.phone),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.black.withOpacity(0.55),
                            ),
                            const SizedBox(width: 6),
                            Expanded(child: Text(data.customer.address)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.black.withOpacity(0.08)),
              const SizedBox(height: 12),

              // Package + Amount row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _Chip(text: data.packageCode),
                  Text(
                    money(data.loanAmount),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              _TwoColRow(
                leftLabel: "Start Date",
                leftValue: fmtDate(data.startDate),
                rightLabel: "End Date",
                rightValue: fmtDate(data.endDate),
              ),
              const SizedBox(height: 10),
              _TwoColRow(
                leftLabel: "Rental",
                leftValue: money(data.rental),
                rightLabel: "Total Paid",
                rightValue: money(data.totalPaid),
              ),

              const SizedBox(height: 10),

              // Outstanding balance row with warning + info icons
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Outstanding Balance",
                      style: TextStyle(color: Colors.black.withOpacity(0.65)),
                    ),
                  ),
                  Text(
                    money(data.outstandingBalance),
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD12B2B),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              Divider(height: 1, color: Colors.black.withOpacity(0.08)),
              const SizedBox(height: 10),

              // Arrears + route
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Arrears ${money(data.arrearsAmount)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFD12B2B),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        data.routeCode,
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        PaymentHistoryTable(rows: data.history, totalPaid: data.totalPaid),
      ],
    );
  }
}

class _TwoColRow extends StatelessWidget {
  const _TwoColRow({
    required this.leftLabel,
    required this.leftValue,
    required this.rightLabel,
    required this.rightValue,
  });

  final String leftLabel;
  final String leftValue;
  final String rightLabel;
  final String rightValue;

  @override
  Widget build(BuildContext context) {
    final labelStyle = TextStyle(color: Colors.black.withOpacity(0.60));
    const valueStyle = TextStyle(fontWeight: FontWeight.w900);

    return Row(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(leftLabel, style: labelStyle),
              Text(leftValue, style: valueStyle),
            ],
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(rightLabel, style: labelStyle),
              Text(rightValue, style: valueStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFDDE7E2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w900,
          color: Color(0xFF1F5B49),
        ),
      ),
    );
  }
}

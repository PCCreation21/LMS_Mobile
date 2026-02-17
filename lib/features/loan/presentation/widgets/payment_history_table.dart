import 'package:flutter/material.dart';
import '../../domain/loan_details_models.dart';

class PaymentHistoryTable extends StatelessWidget {
  const PaymentHistoryTable({
    super.key,
    required this.rows,
    required this.totalPaid,
  });

  final List<PaymentHistoryRow> rows;
  final double totalPaid;

  String _fmtDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return "$dd/$mm/${d.year}";
  }

  String _money(double v) {
    // Keep it simple (you can replace with intl later)
    final s = v.toStringAsFixed(0);
    return "LKR $s";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.70),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              children: [
                const Text(
                  "Payment History",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(width: 10),
                Text(
                  _money(totalPaid),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F5B49),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            child: Row(
              children: [
                Expanded(
                  flex: 26,
                  child: Text(
                    "Payment Date",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.55),
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 22,
                  child: Text(
                    "Paid Amount",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black.withOpacity(0.55),
                      fontSize: 13,
                    ),
                  ),
                ),
                Expanded(
                  flex: 30,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Balance After Pay",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Colors.black.withOpacity(0.55),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: Colors.black.withOpacity(0.08)),

          if (rows.isEmpty)
            const Padding(
              padding: EdgeInsets.all(18),
              child: Text("No payment history"),
            )
          else
            ...rows.map(
              (r) => Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 26,
                          child: Text(_fmtDate(r.paymentDate)),
                        ),
                        Expanded(
                          flex: 22,
                          child: Text(
                            _money(r.paidAmount),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1F5B49),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 30,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _money(r.balanceAfterPayment),
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black.withOpacity(0.70),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Divider(height: 1, color: Colors.black.withOpacity(0.06)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

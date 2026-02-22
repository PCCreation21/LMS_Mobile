import 'package:flutter/material.dart';
import '../../domain/loan_management_models.dart';

class LoanTable extends StatelessWidget {
  const LoanTable({super.key, required this.rows, required this.onRowTap});

  final List<LoanRowModel> rows;
  final ValueChanged<LoanRowModel> onRowTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.65),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.55)),
      ),
      child: Column(
        children: [
          const _Header(),
          const Divider(height: 1),
          ...rows.map((r) => _RowItem(row: r, onTap: () => onRowTap(r))),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    final s = TextStyle(
      fontWeight: FontWeight.w800,
      color: Colors.black.withOpacity(0.55),
      fontSize: 12.5,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Row(
        children: [
          Expanded(flex: 30, child: Text("Loan No.", style: s)),
          Expanded(flex: 35, child: Text("Customer", style: s)),
          Expanded(flex: 25, child: Text("Arrears", style: s)),
          Expanded(
            flex: 10,
            child: Text("Actions", style: s, textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  const _RowItem({required this.row, required this.onTap});

  final LoanRowModel row;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color arrearsColor = (row.arrears.trim() == "-"
        ? Colors.black
        : const Color(0xFFD12B2B));

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 30,
                child: Text(
                  row.loanNo,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F5B49),
                  ),
                ),
              ),
              Expanded(
                flex: 35,
                child: Text(row.customer, overflow: TextOverflow.ellipsis),
              ),
              Expanded(
                flex: 25,
                child: Text(
                  row.arrears,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: arrearsColor,
                  ),
                ),
              ),
              Expanded(
                flex: 10,
                child: IconButton(
                  icon: const Icon(Icons.visibility_outlined, size: 20),
                  onPressed: onTap,
                  color: const Color(0xFF1F5B49),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(height: 1, color: Colors.black.withOpacity(0.07)),
        ],
      ),
    );
  }
}

// class _Chip extends StatelessWidget {
//   const _Chip({required this.text});
//   final String text;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: const Color(0xFFDDE7E2),
//         borderRadius: BorderRadius.circular(14),
//       ),
//       child: Text(
//         text,
//         overflow: TextOverflow.ellipsis,
//         style: const TextStyle(
//           fontWeight: FontWeight.w800,
//           color: Color(0xFF1F5B49),
//         ),
//       ),
//     );
//   }
// }

// class _StatusBadge extends StatelessWidget {
//   const _StatusBadge({required this.status});
//   final LoanStatus status;

//   @override
//   Widget build(BuildContext context) {
//     String t;
//     Color bg;
//     Color fg;

//     switch (status) {
//       case LoanStatus.open:
//         t = "Open";
//         bg = const Color(0xFFDDE7E2);
//         fg = const Color(0xFF1F5B49);
//         break;
//       case LoanStatus.arrears:
//         t = "Arrears";
//         bg = const Color(0xFFFFE0E0);
//         fg = const Color(0xFFD12B2B);
//         break;
//       case LoanStatus.completed:
//         t = "Completed";
//         bg = const Color(0xFFEADDCB);
//         fg = Colors.black.withOpacity(0.55);
//         break;
//       case LoanStatus.closed:
//         t = "Closed";
//         bg = Colors.grey.withOpacity(0.2);
//         fg = Colors.black.withOpacity(0.6);
//         break;
//       case LoanStatus.all:
//         t = "All";
//         bg = Colors.black.withOpacity(0.08);
//         fg = Colors.black.withOpacity(0.7);
//         break;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(999),
//       ),
//       child: Text(
//         t,
//         style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: fg),
//       ),
//     );
//   }
// }

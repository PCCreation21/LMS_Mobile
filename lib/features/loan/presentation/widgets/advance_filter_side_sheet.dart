import 'package:flutter/material.dart';
import '../../domain/loan_management_models.dart';

Future<LoanFilters?> showAdvanceFilterSideSheet({
  required BuildContext context,
  required LoanFilters initial,
}) {
  return showGeneralDialog<LoanFilters?>(
    context: context,
    barrierDismissible: true,
    barrierLabel: "AdvanceFilter",
    barrierColor: Colors.black.withOpacity(0.45),
    transitionDuration: const Duration(milliseconds: 220),
    pageBuilder: (ctx, _, __) => _AdvanceFilterSheet(initial: initial),
    transitionBuilder: (ctx, anim, _, child) {
      final slide = Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut));
      return SlideTransition(position: slide, child: child);
    },
  );
}

class _AdvanceFilterSheet extends StatefulWidget {
  const _AdvanceFilterSheet({required this.initial});
  final LoanFilters initial;

  @override
  State<_AdvanceFilterSheet> createState() => _AdvanceFilterSheetState();
}

class _AdvanceFilterSheetState extends State<_AdvanceFilterSheet> {
  late final TextEditingController nicCtrl;
  late final TextEditingController loanCodeCtrl;

  DateTime? from;
  DateTime? to;

  @override
  void initState() {
    super.initState();
    nicCtrl = TextEditingController(text: widget.initial.nic);
    loanCodeCtrl = TextEditingController(text: widget.initial.loanCode);
    from = widget.initial.from;
    to = widget.initial.to;
  }

  @override
  void dispose() {
    nicCtrl.dispose();
    loanCodeCtrl.dispose();
    super.dispose();
  }

  String _fmt(DateTime? d) {
    if (d == null) return "dd/mm/yyyy";
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return "$dd/$mm/${d.year}";
  }

  Future<void> _pickFrom() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      initialDate: from ?? now,
    );
    if (d != null) setState(() => from = d);
  }

  Future<void> _pickTo() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 10),
      initialDate: to ?? now,
    );
    if (d != null) setState(() => to = d);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final sheetWidth = (w * 0.82).clamp(280, 360).toDouble();

    return Align(
      alignment: Alignment.centerRight,
      child: Material(
        color: Colors.white,
        child: SizedBox(
          width: sheetWidth,
          height: double.infinity,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // top close
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Advance Filter",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),

                  const Text("NIC*"),
                  const SizedBox(height: 6),
                  _Input(ctrl: nicCtrl, hint: "Enter Customer NIC Number"),

                  const SizedBox(height: 14),
                  const Text("Loan Code"),
                  const SizedBox(height: 6),
                  _Input(ctrl: loanCodeCtrl, hint: "Enter Loan Code"),

                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("From"),
                            const SizedBox(height: 6),
                            _DateBox(value: _fmt(from), onTap: _pickFrom),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("To"),
                            const SizedBox(height: 6),
                            _DateBox(value: _fmt(to), onTap: _pickTo),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Center(
                    child: SizedBox(
                      height: 42,
                      width: 120,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD6A11E),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          final res = LoanFilters(
                            nic: nicCtrl.text.trim(),
                            loanCode: loanCodeCtrl.text.trim(),
                            from: from,
                            to: to,
                          );
                          Navigator.pop(context, res);
                        },
                        child: const Text("Apply Filter"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Input extends StatelessWidget {
  const _Input({required this.ctrl, required this.hint});
  final TextEditingController ctrl;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF3F6F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.12)),
          ),
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  const _DateBox({required this.value, required this.onTap});
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F6F5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black.withOpacity(0.12)),
        ),
        alignment: Alignment.centerLeft,
        child: Text(
          value,
          style: TextStyle(
            color: value == "dd/mm/yyyy"
                ? Colors.black.withOpacity(0.45)
                : Colors.black,
          ),
        ),
      ),
    );
  }
}

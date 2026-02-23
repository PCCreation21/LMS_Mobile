import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

import '../state/receipt_controller.dart';
import 'widgets/dashed_divider.dart';
import 'widgets/kv_row.dart';

class PaymentReceiptPage extends ConsumerWidget {
  const PaymentReceiptPage({super.key, required this.receiptId});
  final String receiptId;

  String _money(double v) => "LKR ${v.toStringAsFixed(2)}";

  String _ymd(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  String _time(DateTime d) {
    final hh = d.hour == 0 ? 12 : (d.hour > 12 ? d.hour - 12 : d.hour);
    final mm = d.minute.toString().padLeft(2, '0');
    final ampm = d.hour >= 12 ? "pm" : "am";
    return "$hh:$mm $ampm";
  }

  Future<void> _showPrintOptions(BuildContext context, dynamic data) async {
    final format = await showDialog<PdfPageFormat>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Print Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('58mm (Thermal)'),
              onTap: () => Navigator.pop(context, PdfPageFormat.roll57),
            ),
            ListTile(
              title: const Text('80mm (Thermal)'),
              onTap: () => Navigator.pop(context, PdfPageFormat.roll80),
            ),
            ListTile(
              title: const Text('A4'),
              onTap: () => Navigator.pop(context, PdfPageFormat.a4),
            ),
          ],
        ),
      ),
    );

    if (format != null) {
      await _generateAndSharePdf(data, format);
    }
  }

  Future<void> _generateAndSharePdf(dynamic data, PdfPageFormat format) async {
    final pdf = pw.Document();
    final is58mm = format == PdfPageFormat.roll57;
    final fontSize = is58mm ? 7.0 : 10.0;
    final titleSize = is58mm ? 10.0 : 14.0;
    final headerSize = is58mm ? 12.0 : 18.0;

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    data.companyName,
                    style: pw.TextStyle(
                      fontSize: headerSize,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    data.subtitle,
                    style: pw.TextStyle(fontSize: fontSize + 1),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    "Tel: ${data.tel}",
                    style: pw.TextStyle(fontSize: fontSize),
                  ),
                ],
              ),
            ),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                data.receiptTitle,
                style: pw.TextStyle(
                  fontSize: titleSize,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Divider(),
            _pdfRow("Loan Number:", data.loanNo, fontSize),
            _pdfRow("Customer Name:", data.customerName, fontSize),
            _pdfRow("Loan Code:", data.loanCode, fontSize),
            pw.Divider(),
            _pdfRow("Loan Amount:", _money(data.loanAmount), fontSize),
            _pdfRow("Start Date:", _ymd(data.startDate), fontSize),
            _pdfRow("End Date:", _ymd(data.endDate), fontSize),
            _pdfRow("Duration:", "${data.durationDays} days", fontSize),
            pw.Divider(),
            _pdfRow("Route:", data.route, fontSize),
            _pdfRow(
              "Bill Date:",
              "${_ymd(data.billDateTime)} ${_time(data.billDateTime)}",
              fontSize,
            ),
            _pdfRow("Last Paid Date:", _ymd(data.lastPaidDate), fontSize),
            pw.Divider(),
            _pdfRow("Rental:", _money(data.rental), fontSize),
            _pdfRow("Total Paid Amount:", _money(data.totalPaid), fontSize),
            _pdfRow("Due to Paid:", _money(data.totalDue), fontSize),
            _pdfRow("Today Paid:", _money(data.todayPaid), fontSize),
            _pdfRow("Brought Forward:", _money(data.broughtForward), fontSize),
            _pdfRow("Arrears Amount:", _money(data.arrears), fontSize),
            _pdfRow("Closing Balance:", _money(data.closingBalance), fontSize),
            pw.Divider(),
            pw.Center(
              child: pw.Text(
                "${_ymd(data.billDateTime)}  |  ${_time(data.billDateTime)}",
                style: pw.TextStyle(fontSize: fontSize),
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text(
                "Thank you for your payment!",
                style: pw.TextStyle(
                  fontSize: fontSize + 1,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Center(
              child: pw.Text(
                "Please keep this receipt for your records.",
                style: pw.TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
      ),
    );

    final bytes = await pdf.save();
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/receipt_${data.loanNo}.pdf');
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([
      XFile(file.path),
    ], text: 'Payment Receipt - ${data.loanNo}');
  }

  pw.Widget _pdfRow(String label, String value, double fontSize) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 1),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(label, style: pw.TextStyle(fontSize: fontSize)),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: fontSize,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(receiptProvider(receiptId));
    final data = state.data;

    return Scaffold(
      body: Stack(
        children: [
          // Background like your other screens
          Image.asset(
            'assets/images/onboarding_bg.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar: back + share
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => context.go('/home'),
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: data == null
                            ? null
                            : () async {
                                await _showPrintOptions(context, data);
                              },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.share, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: state.loading
                      ? const Center(child: CircularProgressIndicator())
                      : state.error != null
                      ? Center(child: Text(state.error!))
                      : _ReceiptBody(
                          data: data!,
                          money: _money,
                          ymd: _ymd,
                          time: _time,
                        ),
                ),

                // Close button (fixed bottom like UI)
                Padding(
                  padding: const EdgeInsets.fromLTRB(18, 10, 18, 16),
                  child: SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD6A11E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () => context.go('/home'),
                      child: const Text(
                        "Close",
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReceiptBody extends StatelessWidget {
  const _ReceiptBody({
    required this.data,
    required this.money,
    required this.ymd,
    required this.time,
  });

  final dynamic
  data; // ReceiptModel (kept dynamic to avoid extra import in snippet)
  final String Function(double) money;
  final String Function(DateTime) ymd;
  final String Function(DateTime) time;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 10),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.84),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.65)),
        ),
        child: Column(
          children: [
            // Logo + name
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replace with your real logo asset
                Image.asset(
                  "assets/images/logo.png",
                  width: 48,
                  height: 48,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.account_balance, size: 48),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.companyName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      data.subtitle,
                      style: TextStyle(
                        color: const Color(0xFFD6A11E),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),
            const DashedDivider(),
            const SizedBox(height: 10),

            // Tel line
            Text(
              "Tel: ${data.tel}",
              style: TextStyle(
                color: Colors.black.withOpacity(0.55),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),
            const DashedDivider(),
            const SizedBox(height: 16),

            // PAYMENT RECEIPT title
            Text(
              data.receiptTitle,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),

            const SizedBox(height: 16),
            const DashedDivider(),
            const SizedBox(height: 12),

            // Top details (matches your UI + slip)
            KvRow(label: "Loan Number", value: data.loanNo),
            KvRow(label: "Customer Name:", value: data.customerName),
            KvRow(label: "Loan Code:", value: data.loanCode),

            const SizedBox(height: 10),
            const DashedDivider(),
            const SizedBox(height: 10),

            KvRow(label: "Loan Amount:", value: money(data.loanAmount)),
            KvRow(
              label: "Start Date:",
              value: ymd(data.startDate),
              boldValue: false,
            ),
            KvRow(
              label: "End Date:",
              value: ymd(data.endDate),
              boldValue: false,
            ),
            KvRow(
              label: "Duration:",
              value: "${data.durationDays}",
              boldValue: false,
            ),

            const SizedBox(height: 10),
            const DashedDivider(),
            const SizedBox(height: 10),

            // Slip-specific
            KvRow(label: "Route:", value: data.route),
            KvRow(
              label: "Bill Date:",
              value: "${ymd(data.billDateTime)} ${time(data.billDateTime)}",
              boldValue: false,
            ),
            KvRow(
              label: "Last Paid Date:",
              value: ymd(data.lastPaidDate),
              boldValue: false,
            ),

            const SizedBox(height: 10),
            const DashedDivider(),
            const SizedBox(height: 10),

            // Payment numbers
            KvRow(label: "Rental:", value: money(data.rental)),
            KvRow(label: "Total Paid Amount:", value: money(data.totalPaid)),
            KvRow(label: "Due to Paid:", value: money(data.totalDue)),
            KvRow(label: "Today Paid:", value: money(data.todayPaid)),
            KvRow(label: "Brought Forward:", value: money(data.broughtForward)),
            KvRow(
              label: "Arrears Amount:",
              value: money(data.arrears),
              valueColor: data.arrears > 0
                  ? const Color(0xFFD12B2B)
                  : Colors.black.withOpacity(0.85),
            ),
            KvRow(label: "Closing Balance:", value: money(data.closingBalance)),

            const SizedBox(height: 10),
            const DashedDivider(),
            const SizedBox(height: 14),

            // Footer timestamp centered like UI
            Text(
              "${ymd(data.billDateTime)}  |  ${time(data.billDateTime)}",
              style: TextStyle(
                color: Colors.black.withOpacity(0.55),
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            const Text(
              "Thank you for your payment!",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 4),
            Text(
              "Please keep this receipt for your records.",
              style: TextStyle(
                color: Colors.black.withOpacity(0.60),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

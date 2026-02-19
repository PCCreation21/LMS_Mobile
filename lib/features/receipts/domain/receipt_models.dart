class ReceiptModel {
  // Company
  final String companyName;
  final String subtitle; // e.g. Micro Credit Investment
  final String tel;

  // Receipt meta
  final String receiptTitle; // PAYMENT RECEIPT
  final DateTime billDateTime;

  // Loan / customer
  final String route;
  final String loanNo;
  final String customerName;
  final String loanCode; // e.g. LP004 - Premium 120
  final double loanAmount;
  final int durationDays;
  final DateTime startDate;
  final DateTime endDate;

  // Payments
  final DateTime lastPaidDate;
  final double rental;
  final double totalPaid;
  final double totalDue;
  final double todayPaid;
  final double broughtForward;
  final double arrears;
  final double closingBalance;

  // QR
  final String qrValue; // typically loanId / receiptId / deep link

  const ReceiptModel({
    required this.companyName,
    required this.subtitle,
    required this.tel,
    required this.receiptTitle,
    required this.billDateTime,
    required this.route,
    required this.loanNo,
    required this.customerName,
    required this.loanCode,
    required this.loanAmount,
    required this.durationDays,
    required this.startDate,
    required this.endDate,
    required this.lastPaidDate,
    required this.rental,
    required this.totalPaid,
    required this.totalDue,
    required this.todayPaid,
    required this.broughtForward,
    required this.arrears,
    required this.closingBalance,
    required this.qrValue,
  });
}

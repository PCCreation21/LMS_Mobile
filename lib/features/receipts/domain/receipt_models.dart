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

  factory ReceiptModel.fromJson(Map<String, dynamic> json) {
    final loanAmount = (json['loanAmount'] as num?)?.toDouble() ?? 0.0;
    final totalPaid = (json['totalPaid'] as num?)?.toDouble() ?? 0.0;
    final rental = (json['rental'] as num?)?.toDouble() ?? 0.0;
    final totalDue = loanAmount - totalPaid;
    
    final startDate = json['startDate'] != null
        ? DateTime.parse(json['startDate'])
        : DateTime.now();
    final endDate = json['endDate'] != null
        ? DateTime.parse(json['endDate'])
        : DateTime.now();
    
    final durationDays = json['timePeriod'] ?? endDate.difference(startDate).inDays;
    
    return ReceiptModel(
      companyName: "Golden Cash",
      subtitle: "Micro Credit Investment",
      tel: "+94 11 234 5678",
      receiptTitle: "PAYMENT RECEIPT",
      billDateTime: DateTime.now(),
      route: json['routeCode'] ?? '',
      loanNo: json['loanNumber'] ?? '',
      customerName: json['customerName'] ?? '',
      loanCode: json['packageCode'] ?? '',
      loanAmount: loanAmount,
      durationDays: durationDays,
      startDate: startDate,
      endDate: endDate,
      lastPaidDate: json['lastPaidDate'] != null
          ? DateTime.parse(json['lastPaidDate'])
          : DateTime.now(),
      rental: rental,
      totalPaid: totalPaid,
      totalDue: totalDue,
      todayPaid: 0,
      broughtForward: totalDue,
      arrears: (json['arrears'] as num?)?.toDouble() ?? 0.0,
      closingBalance: totalDue,
      qrValue: "goldencash://loan/${json['loanNumber'] ?? ''}",
    );
  }
}

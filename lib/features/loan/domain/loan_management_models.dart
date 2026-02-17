enum LoanStatus { all, open, arrears, completed, closed }

class LoanFilters {
  final String nic;
  final String loanCode;
  final DateTime? from;
  final DateTime? to;

  const LoanFilters({this.nic = "", this.loanCode = "", this.from, this.to});

  LoanFilters copyWith({
    String? nic,
    String? loanCode,
    DateTime? from,
    DateTime? to,
  }) {
    return LoanFilters(
      nic: nic ?? this.nic,
      loanCode: loanCode ?? this.loanCode,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

class LoanRowModel {
  // 5 columns for mobile
  final String loanNo;
  final String customer;
  final String packageCode;
  final String arrears; // e.g. "LKR 19,160" or "-"
  final LoanStatus status;

  // keep id for next page
  final String loanId;

  const LoanRowModel({
    required this.loanId,
    required this.loanNo,
    required this.customer,
    required this.packageCode,
    required this.arrears,
    required this.status,
  });
}

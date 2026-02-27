class LoanPackageLite {
  final String id;
  final String name;
  final int durationDays;

  const LoanPackageLite({
    required this.id,
    required this.name,
    required this.durationDays,
  });

  factory LoanPackageLite.fromJson(Map<String, dynamic> json) {
    return LoanPackageLite(
      id: json['packageCode'] ?? '',
      name: json['packageName'] ?? '',
      durationDays: json['timePeriod'] ?? 0,
    );
  }
}

class IssueLoanRequest {
  final String nic;
  final double amount;
  final String loanPackageId;
  final DateTime startDate;
  final DateTime endDate;

  const IssueLoanRequest({
    required this.nic,
    required this.amount,
    required this.loanPackageId,
    required this.startDate,
    required this.endDate,
  });
}

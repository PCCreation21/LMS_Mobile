class LoanPackageLite {
  final String id;
  final String name;
  final int durationMonths;

  const LoanPackageLite({
    required this.id,
    required this.name,
    required this.durationMonths,
  });
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

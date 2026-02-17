enum LoanStatus { open, arrears, completed }

class PaymentHistoryRow {
  final DateTime paymentDate;
  final double paidAmount;
  final double balanceAfterPayment;

  const PaymentHistoryRow({
    required this.paymentDate,
    required this.paidAmount,
    required this.balanceAfterPayment,
  });
}

class LoanCustomerInfo {
  final String name;
  final String nic;
  final String phone;
  final String address;
  final String? avatarAsset;

  const LoanCustomerInfo({
    required this.name,
    required this.nic,
    required this.phone,
    required this.address,
    this.avatarAsset,
  });
}

class LoanDetailsModel {
  final String loanId; // LN20240001
  final LoanStatus status;

  final LoanCustomerInfo customer;

  final String packageCode; // LP001
  final double loanAmount;

  final DateTime startDate;
  final DateTime endDate;

  final double rental;
  final double totalPaid;
  final double outstandingBalance;
  final double arrearsAmount;

  final String routeCode; // R001

  final List<PaymentHistoryRow> history;

  const LoanDetailsModel({
    required this.loanId,
    required this.status,
    required this.customer,
    required this.packageCode,
    required this.loanAmount,
    required this.startDate,
    required this.endDate,
    required this.rental,
    required this.totalPaid,
    required this.outstandingBalance,
    required this.arrearsAmount,
    required this.routeCode,
    required this.history,
  });
}

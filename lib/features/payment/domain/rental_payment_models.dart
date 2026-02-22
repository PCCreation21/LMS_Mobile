enum PaymentMethod { cash, card, loan }

class RentalPaymentListItem {
  final String id;

  final String customerName;
  final String nic;
  final String loanNo;

  final double amount;
  final String collectedBy;
  final String paymentDate;
  final String? remark;

  const RentalPaymentListItem({
    required this.id,
    required this.customerName,
    required this.nic,
    required this.loanNo,
    required this.amount,
    required this.collectedBy,
    required this.paymentDate,
    this.remark,
  });
}

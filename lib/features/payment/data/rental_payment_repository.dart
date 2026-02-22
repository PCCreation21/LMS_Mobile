import 'package:loan_management_system/features/payment/domain/rental_payment_models.dart';

abstract class RentalPaymentsRepository {
  Future<List<RentalPaymentListItem>> fetchRentalPayments();
}

class RentalPaymentsRepositoryImpl implements RentalPaymentsRepository {
  @override
  Future<List<RentalPaymentListItem>> fetchRentalPayments() async {
    await Future.delayed(const Duration(milliseconds: 350));

    return const [
      RentalPaymentListItem(
        id: "1",
        customerName: "Anna Perera",
        nic: "940012345V",
        loanNo: "LN2023001",
        amount: 150.00,
        collectedBy: "Officer 001",
        paymentDate: "2024-01-15",
        remark: "Partial payment",
      ),
      RentalPaymentListItem(
        id: "2",
        customerName: "Ravi Senanayake",
        nic: "880045678V",
        loanNo: "LN2023002",
        amount: 200.00,
        collectedBy: "Officer 002",
        paymentDate: "2024-01-16",
      ),
      RentalPaymentListItem(
        id: "3",
        customerName: "Kasun Fernando",
        nic: "200012345678",
        loanNo: "LN2023005",
        amount: 5000.00,
        collectedBy: "Officer 001",
        paymentDate: "2024-01-17",
        remark: "Advance payment",
      ),
      RentalPaymentListItem(
        id: "4",
        customerName: "Nimal Silva",
        nic: "967812345V",
        loanNo: "LN2023006",
        amount: 500.00,
        collectedBy: "Officer 003",
        paymentDate: "2024-01-18",
        remark: "Late payment",
      ),
      RentalPaymentListItem(
        id: "5",
        customerName: "Chamari Silva",
        nic: "996712345V",
        loanNo: "LN2023003",
        amount: 500.00,
        collectedBy: "Officer 002",
        paymentDate: "2024-01-19",
      ),
      RentalPaymentListItem(
        id: "6",
        customerName: "Nimal Silva",
        nic: "996712345V",
        loanNo: "LN2023003",
        amount: 500.00,
        collectedBy: "Officer 001",
        paymentDate: "2024-01-20",
      ),
    ];
  }
}

import '../../../core/networking/api_client.dart';
import '../../../core/networking/endpoints.dart';
import '../../customer/domain/customer_models.dart';
import '../domain/loan_models.dart';
import '../domain/loan_management_models.dart' as management;
import '../domain/loan_details_models.dart' as details;

class LoanRepository {
  final ApiClient _apiClient;

  LoanRepository(this._apiClient);

  Future<Customer> getCustomerByNic(String nic) async {
    final response = await _apiClient.get(ApiEndpoints.customerByNic(nic));
    return Customer.fromJson(response.data);
  }

  Future<List<LoanPackageLite>> getLoanPackages() async {
    final response = await _apiClient.get(ApiEndpoints.loanPackages);
    return (response.data as List)
        .map((json) => LoanPackageLite.fromJson(json))
        .toList();
  }

  Future<List<management.LoanRowModel>> getLoans({
    management.LoanStatus? status,
    String? routeCode,
    String? nic,
  }) async {
    final queryParams = <String, dynamic>{};

    if (status != null && status != management.LoanStatus.all) {
      queryParams['status'] = status.name.toUpperCase();
    }
    if (routeCode != null && routeCode.isNotEmpty) {
      queryParams['routeCode'] = routeCode;
    }
    if (nic != null && nic.isNotEmpty) {
      queryParams['nic'] = nic;
    }

    final response = await _apiClient.get(
      ApiEndpoints.loans,
      queryParameters: queryParams,
    );

    return (response.data as List)
        .map((json) => management.LoanRowModel.fromJson(json))
        .toList();
  }

  Future<String> issueLoan({
    required String nic,
    required double amount,
    required String loanPackageCode,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await _apiClient.post(
      ApiEndpoints.loans,
      data: {
        'customerNic': nic,
        'amount': amount,
        'packageCode': loanPackageCode,
        'startDate': startDate.toIso8601String().split('T')[0],
      },
    );
    return response.data['loanNumber'];
  }

  Future<details.LoanDetailsModel> getLoanDetails(String loanNumber) async {
    final response = await _apiClient.get(
      ApiEndpoints.loanByNumber(loanNumber),
    );
    final data = response.data;

    // Fetch customer details for phone and address
    String phone = '';
    String address = '';
    try {
      final customerResponse = await _apiClient.get(
        ApiEndpoints.customerByNic(data['customerNic']),
      );
      phone = customerResponse.data['phoneNumber'] ?? '';
      address = customerResponse.data['address'] ?? '';
    } catch (e) {
      // Continue without customer details if fetch fails
    }

    List<details.PaymentHistoryRow> paymentList = [];
    try {
      final payments = await _apiClient.get(
        ApiEndpoints.paymentsByLoan(loanNumber),
      );
      paymentList = (payments.data as List)
          .map(
            (p) => details.PaymentHistoryRow(
              paymentDate: DateTime.parse(p['paymentDate']),
              paidAmount: (p['amount'] as num).toDouble(),
              balanceAfterPayment: (p['balanceAfterPayment'] as num).toDouble(),
            ),
          )
          .toList();
    } catch (e) {
      // If payment history fails, continue with empty list
    }

    return details.LoanDetailsModel(
      loanId: data['loanNumber'],
      status: _parseStatus(data['status']),
      customer: details.LoanCustomerInfo(
        name: data['customerName'],
        nic: data['customerNic'],
        phone: phone,
        address: address,
        avatarAsset: null,
      ),
      packageCode: data['packageCode'],
      loanAmount: (data['loanAmount'] as num).toDouble(),
      startDate: DateTime.parse(data['startDate']),
      endDate: DateTime.parse(data['endDate']),
      rental: (data['rentalAmount'] as num).toDouble(),
      totalPaid: (data['totalPaidAmount'] as num).toDouble(),
      outstandingBalance: (data['outstandingBalance'] as num).toDouble(),
      arrearsAmount: ((data['arrearsAmount'] ?? 0) as num).toDouble(),
      routeCode: data['routeCode'] ?? '',
      history: paymentList,
    );
  }

  details.LoanStatus _parseStatus(String status) {
    switch (status.toUpperCase()) {
      case 'OPEN':
        return details.LoanStatus.open;
      case 'ARREARS':
        return details.LoanStatus.arrears;
      case 'COMPLETED':
        return details.LoanStatus.completed;
      default:
        return details.LoanStatus.open;
    }
  }
}

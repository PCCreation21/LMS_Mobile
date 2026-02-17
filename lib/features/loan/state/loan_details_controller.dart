import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/loan_details_models.dart';

final loanDetailsProvider =
    StateNotifierProvider.family<
      LoanDetailsController,
      LoanDetailsState,
      String
    >((ref, loanId) => LoanDetailsController(ref, loanId));

class LoanDetailsState {
  final bool loading;
  final String? error;
  final LoanDetailsModel? data;

  const LoanDetailsState({required this.loading, this.error, this.data});

  factory LoanDetailsState.initial() => const LoanDetailsState(loading: true);

  LoanDetailsState copyWith({
    bool? loading,
    String? error,
    LoanDetailsModel? data,
    bool clearError = false,
  }) {
    return LoanDetailsState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
    );
  }
}

class LoanDetailsController extends StateNotifier<LoanDetailsState> {
  LoanDetailsController(this.ref, this.loanId)
    : super(LoanDetailsState.initial()) {
    load();
  }

  final Ref ref;
  final String loanId;

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      // TODO: replace with API call: GET /loans/{loanId}/details + /history
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data similar to your UI
      final mock = LoanDetailsModel(
        loanId: loanId,
        status: LoanStatus.open,
        customer: const LoanCustomerInfo(
          name: "Amara Perera",
          nic: "199512345678",
          phone: "+94 77 123 4567",
          address: "45 Temple Road, Colombo 06",
          avatarAsset: "assets/images/sample_user.png",
        ),
        packageCode: "LP001",
        loanAmount: 100000,
        startDate: DateTime(2024, 1, 15),
        endDate: DateTime(2024, 2, 14),
        rental: 3667,
        totalPaid: 18335,
        outstandingBalance: 81665,
        arrearsAmount: 22002,
        routeCode: "R001",
        history: [
          PaymentHistoryRow(
            paymentDate: DateTime(2024, 2, 14),
            paidAmount: 3667,
            balanceAfterPayment: 81665,
          ),
          PaymentHistoryRow(
            paymentDate: DateTime(2024, 2, 7),
            paidAmount: 3667,
            balanceAfterPayment: 85332,
          ),
          PaymentHistoryRow(
            paymentDate: DateTime(2024, 2, 1),
            paidAmount: 11001,
            balanceAfterPayment: 88999,
          ),
        ],
      );

      state = state.copyWith(loading: false, data: mock);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Failed to load loan details",
      );
    }
  }
}

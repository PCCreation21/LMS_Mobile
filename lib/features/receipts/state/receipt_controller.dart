import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/receipt_models.dart';

final receiptProvider =
    StateNotifierProvider.family<ReceiptController, ReceiptState, String>(
      (ref, receiptId) => ReceiptController(ref, receiptId),
    );

class ReceiptState {
  final bool loading;
  final String? error;
  final ReceiptModel? data;

  const ReceiptState({required this.loading, this.error, this.data});

  factory ReceiptState.initial() => const ReceiptState(loading: true);

  ReceiptState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    ReceiptModel? data,
  }) {
    return ReceiptState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      data: data ?? this.data,
    );
  }
}

class ReceiptController extends StateNotifier<ReceiptState> {
  ReceiptController(this.ref, this.receiptId) : super(ReceiptState.initial()) {
    load();
  }

  final Ref ref;
  final String receiptId;

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      // TODO: Replace with API call: GET /receipts/{receiptId}
      await Future.delayed(const Duration(milliseconds: 350));

      // Mock mapped to BOTH: your UI + customer's real slip fields
      final mock = ReceiptModel(
        companyName: "Golden Cash",
        subtitle: "Micro Credit Investment",
        tel: "+94 11 234 5678",
        receiptTitle: "PAYMENT RECEIPT",
        billDateTime: DateTime(2024, 4, 24, 9, 41),

        route: "KATUGASTOTA",
        loanNo: "LN2023005",
        customerName: "Kasun Fernando",
        loanCode: "LP004 - Premium 120",
        loanAmount: 100000,
        durationDays: 120,
        startDate: DateTime(2024, 1, 25),
        endDate: DateTime(2024, 5, 24),

        lastPaidDate: DateTime(2024, 4, 24),
        rental: 5000,
        totalPaid: 55000,
        totalDue: 45000,
        todayPaid: 500,
        broughtForward: 18485,
        arrears: 0,
        closingBalance: 18485,

        // Use deep-link later:
        qrValue: "goldencash://loan/LN2023005",
      );

      state = state.copyWith(loading: false, data: mock);
    } catch (e) {
      state = state.copyWith(loading: false, error: "Failed to load receipt");
    }
  }
}

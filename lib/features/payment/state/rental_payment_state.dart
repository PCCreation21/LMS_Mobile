import 'package:loan_management_system/features/payment/domain/rental_payment_models.dart';

class RentalPaymentsState {
  final bool loading;
  final String? error;

  final String query;
  final List<RentalPaymentListItem> all;
  final List<RentalPaymentListItem> filtered;

  const RentalPaymentsState({
    required this.loading,
    required this.query,
    required this.all,
    required this.filtered,
    this.error,
  });

  factory RentalPaymentsState.initial() => const RentalPaymentsState(
    loading: false,
    query: "",
    all: [],
    filtered: [],
    error: null,
  );

  RentalPaymentsState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    String? query,
    List<RentalPaymentListItem>? all,
    List<RentalPaymentListItem>? filtered,
  }) {
    return RentalPaymentsState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      query: query ?? this.query,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
    );
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:loan_management_system/features/payment/data/rental_payment_repository.dart';
import 'package:loan_management_system/features/payment/domain/rental_payment_models.dart';
import 'package:loan_management_system/features/payment/state/rental_payment_state.dart';

final rentalPaymentsRepositoryProvider = Provider<RentalPaymentsRepository>(
  (ref) => RentalPaymentsRepositoryImpl(),
);

final rentalPaymentsProvider =
    StateNotifierProvider<RentalPaymentsController, RentalPaymentsState>(
      (ref) => RentalPaymentsController(
        repo: ref.read(rentalPaymentsRepositoryProvider),
      ),
    );

class RentalPaymentsController extends StateNotifier<RentalPaymentsState> {
  RentalPaymentsController({required this.repo})
    : super(RentalPaymentsState.initial()) {
    load();
  }

  final RentalPaymentsRepository repo;

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final data = await repo.fetchRentalPayments();
      state = state.copyWith(
        loading: false,
        all: data,
        filtered: _applyQuery(data, state.query),
      );
    } catch (_) {
      state = state.copyWith(
        loading: false,
        error: "Failed to load rental payments",
      );
    }
  }

  void setQuery(String q) {
    final next = q;
    state = state.copyWith(
      query: next,
      filtered: _applyQuery(state.all, next),
      clearError: true,
    );
  }

  List<RentalPaymentListItem> _applyQuery(
    List<RentalPaymentListItem> items,
    String q,
  ) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return items;

    return items.where((e) {
      return e.nic.toLowerCase().contains(query) ||
          e.customerName.toLowerCase().contains(query) ||
          e.loanNo.toLowerCase().contains(query);
    }).toList();
  }
}

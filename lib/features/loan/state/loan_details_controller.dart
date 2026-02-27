import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/loan_details_models.dart';
import '../data/loan_repository.dart';
import '../../auth/state/auth_controller.dart';

final _loanRepoProvider = Provider((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LoanRepository(apiClient);
});

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
      final repo = ref.read(_loanRepoProvider);
      final data = await repo.getLoanDetails(loanId);
      state = state.copyWith(loading: false, data: data);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Failed to load loan details: ${e.toString()}",
      );
    }
  }
}

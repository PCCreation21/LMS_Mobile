import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../auth/state/auth_controller.dart';
import '../data/receipt_repository.dart';
import '../domain/receipt_models.dart';

final receiptRepositoryProvider = Provider<ReceiptRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return ReceiptRepository(apiClient);
});

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
      final repo = ref.read(receiptRepositoryProvider);
      final receipt = await repo.getLoanReceipt(receiptId);
      state = state.copyWith(loading: false, data: receipt);
    } catch (e) {
      state = state.copyWith(loading: false, error: "Failed to load receipt");
    }
  }
}

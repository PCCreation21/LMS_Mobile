import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:loan_management_system/features/loan/domain/loan_models.dart';
import '../../auth/state/auth_controller.dart';
import '../data/loan_repository.dart';

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LoanRepository(apiClient);
});

final issueLoanControllerProvider =
    StateNotifierProvider<IssueLoanController, IssueLoanState>(
      (ref) => IssueLoanController(ref),
    );

class IssueLoanState {
  final bool isLoading;
  final String? error;

  final List<LoanPackageLite> packages;

  final String customerName;
  final LoanPackageLite? selectedPackage;

  final DateTime? startDate;
  final DateTime? endDate;

  const IssueLoanState({
    this.isLoading = false,
    this.error,
    this.packages = const [],
    this.customerName = "",
    this.selectedPackage,
    this.startDate,
    this.endDate,
  });

  IssueLoanState copyWith({
    bool? isLoading,
    String? error,
    List<LoanPackageLite>? packages,
    String? customerName,
    LoanPackageLite? selectedPackage,
    DateTime? startDate,
    DateTime? endDate,
    bool clearError = false,
  }) {
    return IssueLoanState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
      packages: packages ?? this.packages,
      customerName: customerName ?? this.customerName,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  factory IssueLoanState.initial() => const IssueLoanState();
}

class IssueLoanController extends StateNotifier<IssueLoanState> {
  IssueLoanController(this.ref) : super(IssueLoanState.initial()) {
    _loadLoanPackages();
  }

  final Ref ref;

  Future<void> _loadLoanPackages() async {
    try {
      final repo = ref.read(loanRepositoryProvider);
      final packages = await repo.getLoanPackages();
      state = state.copyWith(packages: packages);
    } catch (e) {
      // Keep default packages if API fails
    }
  }

  void resetForm() {
    state = IssueLoanState(packages: state.packages);
  }

  Future<void> searchCustomerByNic(String nic) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(loanRepositoryProvider);
      final customer = await repo.getCustomerByNic(nic.trim());
      state = state.copyWith(isLoading: false, customerName: customer.name);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        customerName: "",
        error: "Customer not found for this NIC",
      );
    }
  }

  void selectPackage(LoanPackageLite? pkg) {
    final end = _calcEndDate(state.startDate, pkg);
    state = state.copyWith(
      selectedPackage: pkg,
      endDate: end,
      clearError: true,
    );
  }

  void setStartDate(DateTime? d) {
    final end = _calcEndDate(d, state.selectedPackage);
    state = state.copyWith(startDate: d, endDate: end, clearError: true);
  }

  DateTime? _calcEndDate(DateTime? start, LoanPackageLite? pkg) {
    if (start == null || pkg == null) return null;
    return start.add(Duration(days: pkg.durationDays));
  }

  Future<String?> issueLoan({
    required String nic,
    required double amount,
    required LoanPackageLite pkg,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final repo = ref.read(loanRepositoryProvider);
      final loanNumber = await repo.issueLoan(
        nic: nic.trim(),
        amount: amount,
        loanPackageCode: pkg.id,
        startDate: startDate,
        endDate: endDate,
      );
      state = state.copyWith(isLoading: false);
      return loanNumber;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Issue loan failed");
      return null;
    }
  }
}

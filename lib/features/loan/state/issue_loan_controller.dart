import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:loan_management_system/features/loan/domain/loan_models.dart';

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

  factory IssueLoanState.initial() => const IssueLoanState(
    packages: [
      LoanPackageLite(id: "LP001", name: "3 Months Package", durationMonths: 3),
      LoanPackageLite(id: "LP002", name: "6 Months Package", durationMonths: 6),
      LoanPackageLite(
        id: "LP003",
        name: "12 Months Package",
        durationMonths: 12,
      ),
    ],
  );
}

class IssueLoanController extends StateNotifier<IssueLoanState> {
  IssueLoanController(this.ref) : super(IssueLoanState.initial());

  final Ref ref;

  Future<void> searchCustomerByNic(String nic) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(milliseconds: 700));

      // Mock: if NIC ends with 5 => not found
      if (nic.trim().endsWith("5")) {
        state = state.copyWith(
          isLoading: false,
          customerName: "",
          error: "Customer not found for this NIC",
        );
        return;
      }

      state = state.copyWith(isLoading: false, customerName: "John Doe");
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Search failed");
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

    // endDate = startDate + durationMonths (same day)
    final y = start.year;
    final m = start.month + pkg.durationMonths;
    final newYear = y + ((m - 1) ~/ 12);
    final newMonth = ((m - 1) % 12) + 1;

    // Keep day safe (avoid invalid dates like Feb 30)
    final lastDay = DateTime(newYear, newMonth + 1, 0).day;
    final day = start.day > lastDay ? lastDay : start.day;

    return DateTime(newYear, newMonth, day);
  }

  Future<bool> issueLoan({
    required String nic,
    required double amount,
    required LoanPackageLite pkg,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      // TODO: Replace with API call
      await Future.delayed(const Duration(seconds: 1));

      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: "Issue loan failed");
      return false;
    }
  }
}

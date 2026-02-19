import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/loan_package_models.dart';

final loanPackageProvider =
    StateNotifierProvider<LoanPackageController, LoanPackageState>(
      (ref) => LoanPackageController(ref),
    );

class LoanPackageState {
  final bool loading;
  final String? error;

  final LoanPackageFilters filters;
  final List<LoanPackageRowModel> rows;

  const LoanPackageState({
    required this.loading,
    required this.filters,
    required this.rows,
    this.error,
  });

  factory LoanPackageState.initial() => const LoanPackageState(
    loading: false,
    filters: LoanPackageFilters(),
    rows: [],
  );

  LoanPackageState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    LoanPackageFilters? filters,
    List<LoanPackageRowModel>? rows,
  }) {
    return LoanPackageState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      filters: filters ?? this.filters,
      rows: rows ?? this.rows,
    );
  }
}

class LoanPackageController extends StateNotifier<LoanPackageState> {
  LoanPackageController(this.ref) : super(LoanPackageState.initial()) {
    load();
  }

  final Ref ref;

  void setSearchBy(LoanPackageSearchBy v) {
    state = state.copyWith(
      filters: state.filters.copyWith(searchBy: v),
      clearError: true,
    );
  }

  void setQuery(String q) {
    state = state.copyWith(
      filters: state.filters.copyWith(query: q),
      clearError: true,
    );
  }

  Future<void> search() => load();

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      // TODO: Replace with API call using:
      // state.filters.searchBy + state.filters.query
      await Future.delayed(const Duration(milliseconds: 450));

      final all = <LoanPackageRowModel>[
        LoanPackageRowModel(
          packageId: "1",
          packageCode: "LP001",
          packageName: "Quick Cash 30",
          timePeriodDays: 30,
          interestRatePercent: 10,
          createdDate: DateTime(2024, 1, 21),
        ),
        LoanPackageRowModel(
          packageId: "2",
          packageCode: "LP002",
          packageName: "Standard 60",
          timePeriodDays: 60,
          interestRatePercent: 15,
          createdDate: DateTime(2024, 1, 21),
        ),
        LoanPackageRowModel(
          packageId: "3",
          packageCode: "LP003",
          packageName: "Extended 90",
          timePeriodDays: 90,
          interestRatePercent: 18,
          createdDate: DateTime(2024, 1, 21),
        ),
        LoanPackageRowModel(
          packageId: "4",
          packageCode: "LP004",
          packageName: "Premium 120",
          timePeriodDays: 120,
          interestRatePercent: 20,
          createdDate: DateTime(2024, 1, 21),
        ),
      ];

      final f = state.filters;
      final q = f.query.trim().toLowerCase();

      final filtered = all.where((p) {
        if (q.isEmpty) return true;

        switch (f.searchBy) {
          case LoanPackageSearchBy.all:
            return p.packageCode.toLowerCase().contains(q) ||
                p.packageName.toLowerCase().contains(q);
          case LoanPackageSearchBy.code:
            return p.packageCode.toLowerCase().contains(q);
          case LoanPackageSearchBy.name:
            return p.packageName.toLowerCase().contains(q);
        }
      }).toList();

      state = state.copyWith(loading: false, rows: filtered);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Failed to load loan packages",
      );
    }
  }
}

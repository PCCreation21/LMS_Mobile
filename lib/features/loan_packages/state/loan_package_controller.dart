import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../auth/state/auth_controller.dart';
import '../data/loan_package_repository.dart';
import '../domain/loan_package_models.dart';

final loanPackageRepositoryProvider = Provider<LoanPackageRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LoanPackageRepository(apiClient);
});

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
      final repo = ref.read(loanPackageRepositoryProvider);
      List<LoanPackageRowModel> packages;

      final f = state.filters;
      final q = f.query.trim();

      if (q.isEmpty) {
        packages = await repo.getLoanPackages();
      } else {
        switch (f.searchBy) {
          case LoanPackageSearchBy.all:
            packages = await repo.getLoanPackages();
            packages = packages.where((p) {
              final query = q.toLowerCase();
              return p.packageCode.toLowerCase().contains(query) ||
                  p.packageName.toLowerCase().contains(query);
            }).toList();
            break;
          case LoanPackageSearchBy.code:
            packages = await repo.searchByCode(q);
            break;
          case LoanPackageSearchBy.name:
            packages = await repo.searchByName(q);
            break;
        }
      }

      state = state.copyWith(loading: false, rows: packages);
    } catch (e, stackTrace) {
      print('Error loading loan packages: $e');
      print('Stack trace: $stackTrace');
      state = state.copyWith(
        loading: false,
        error: "Failed to load loan packages: $e",
      );
    }
  }

  Future<void> deleteLoanPackage(String packageCode) async {
    try {
      final repo = ref.read(loanPackageRepositoryProvider);
      await repo.deleteLoanPackage(packageCode);
      await load();
    } catch (e) {
      state = state.copyWith(error: "Failed to delete loan package");
    }
  }
}

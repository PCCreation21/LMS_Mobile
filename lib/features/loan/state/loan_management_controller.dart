import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../../auth/state/auth_controller.dart';
import '../data/loan_repository.dart';
import '../domain/loan_management_models.dart';

final loanManagementRepositoryProvider = Provider<LoanRepository>((ref) {
  final apiClient = ref.read(apiClientProvider);
  return LoanRepository(apiClient);
});

final loanManagementProvider =
    StateNotifierProvider<LoanManagementController, LoanManagementState>(
      (ref) => LoanManagementController(ref),
    );

class LoanManagementState {
  final bool loading;
  final String? error;

  // Filters (top bar)
  final LoanStatus status;
  final List<String> routes; // e.g. ["All Routes","R001","R002"]
  final String? selectedRoute; // null => All Routes

  // Advance Filter (side sheet)
  final LoanFilters filters;

  // Table rows (mobile 5 columns)
  final List<LoanRowModel> rows;

  const LoanManagementState({
    required this.loading,
    required this.status,
    required this.routes,
    required this.selectedRoute,
    required this.filters,
    required this.rows,
    this.error,
  });

  factory LoanManagementState.initial() => const LoanManagementState(
    loading: false,
    error: null,
    status: LoanStatus.all,
    routes: ["All Routes", "R001", "R002", "R003", "R004"],
    selectedRoute: null, // null == All Routes
    filters: LoanFilters(),
    rows: [],
  );

  LoanManagementState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,

    LoanStatus? status,
    List<String>? routes,
    String? selectedRoute,
    bool setSelectedRouteNull = false, // helper

    LoanFilters? filters,
    List<LoanRowModel>? rows,
  }) {
    return LoanManagementState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),

      status: status ?? this.status,
      routes: routes ?? this.routes,

      selectedRoute: setSelectedRouteNull
          ? null
          : (selectedRoute ?? this.selectedRoute),

      filters: filters ?? this.filters,
      rows: rows ?? this.rows,
    );
  }
}

class LoanManagementController extends StateNotifier<LoanManagementState> {
  LoanManagementController(this.ref) : super(LoanManagementState.initial()) {
    load();
  }

  final Ref ref;

  void setStatus(LoanStatus s) {
    state = state.copyWith(status: s, clearError: true);
  }

  /// route == null means "All Routes"
  void setRoute(String? route) {
    if (route == null || route.trim().isEmpty || route == "All Routes") {
      state = state.copyWith(setSelectedRouteNull: true, clearError: true);
      return;
    }
    state = state.copyWith(selectedRoute: route, clearError: true);
  }

  void applyFilters(LoanFilters f) {
    state = state.copyWith(filters: f, clearError: true);
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      final repo = ref.read(loanManagementRepositoryProvider);

      final selectedStatus = state.status;
      final selectedRoute = state.selectedRoute;
      final f = state.filters;

      List<LoanRowModel> loans = await repo.getLoans(
        status: selectedStatus,
        routeCode: selectedRoute,
        nic: f.nic.trim().isEmpty ? null : f.nic.trim(),
      );

      // Client-side filter for loan code if needed
      if (f.loanCode.trim().isNotEmpty) {
        loans = loans.where((loan) {
          return loan.loanNo.toLowerCase().contains(
            f.loanCode.trim().toLowerCase(),
          );
        }).toList();
      }

      state = state.copyWith(loading: false, rows: loans);
    } catch (e) {
      state = state.copyWith(loading: false, error: "Failed to load loans");
    }
  }
}

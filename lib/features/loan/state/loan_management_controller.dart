import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/loan_management_models.dart';

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
      // ✅ These are the values you send to API
      final selectedStatus = state.status; // All / Active / Overdue / Completed
      final selectedRoute = state.selectedRoute; // null => All Routes
      final f = state.filters; // NIC, LoanCode, From/To

      // TODO: Replace with API call using:
      // selectedStatus, selectedRoute, f.nic, f.loanCode, f.from, f.to
      await Future.delayed(const Duration(milliseconds: 500));

      // ---- MOCK DATA (add route into mock so you can filter) ----
      final all = <_LoanRowInternal>[
        const _LoanRowInternal(
          row: LoanRowModel(
            loanId: "1",
            loanNo: "LN20240001",
            customer: "Amara Perera",
            packageCode: "LP001",
            arrears: "-",
            status: LoanStatus.open,
          ),
          route: "R001",
          nic: "200012345V",
        ),
        const _LoanRowInternal(
          row: LoanRowModel(
            loanId: "2",
            loanNo: "LN20240002",
            customer: "Kamal Silva",
            packageCode: "LP002",
            arrears: "LKR 19,160",
            status: LoanStatus.arrears,
          ),
          route: "R004",
          nic: "199976543V",
        ),
        const _LoanRowInternal(
          row: LoanRowModel(
            loanId: "3",
            loanNo: "LN20230015",
            customer: "Nimal Fernando",
            packageCode: "LP003",
            arrears: "-",
            status: LoanStatus.completed,
          ),
          route: "R003",
          nic: "199912312V",
        ),
      ];

      // ---- FILTERING ----
      final filtered = all
          .where((x) {
            final r = x.row;

            // 1) Status filter
            final okStatus =
                selectedStatus == LoanStatus.all || r.status == selectedStatus;

            // 2) Route filter
            final okRoute = selectedRoute == null
                ? true
                : x.route.toLowerCase() == selectedRoute.toLowerCase();

            // 3) Advanced filter: NIC
            final okNic = f.nic.trim().isEmpty
                ? true
                : x.nic.toLowerCase().contains(f.nic.trim().toLowerCase());

            // 4) Advanced filter: Loan Code
            final okLoanCode = f.loanCode.trim().isEmpty
                ? true
                : r.loanNo.toLowerCase().contains(
                    f.loanCode.trim().toLowerCase(),
                  );

            // 5) Advanced filter: From/To dates
            // In this mock, we don't have real date field, so we skip.
            // When you have real loanDate, implement date checks here.

            return okStatus && okRoute && okNic && okLoanCode;
          })
          .map((x) => x.row)
          .toList();

      state = state.copyWith(loading: false, rows: filtered);
    } catch (e) {
      state = state.copyWith(loading: false, error: "Failed to load loans");
    }
  }
}

/// Internal helper for mock filtering (route, nic, etc.)
class _LoanRowInternal {
  final LoanRowModel row;
  final String route;
  final String nic;

  const _LoanRowInternal({
    required this.row,
    required this.route,
    required this.nic,
  });
}

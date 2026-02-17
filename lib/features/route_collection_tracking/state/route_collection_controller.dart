import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/route_collection_models.dart';

final routeCollectionProvider =
    StateNotifierProvider<RouteCollectionController, RouteCollectionState>(
      (ref) => RouteCollectionController(ref),
    );

class RouteCollectionState {
  final bool loading;
  final String? error;

  final RouteCollectionFilters filters;

  final List<String> routeCodes; // includes "All"
  final List<String> officers; // includes "All"

  final List<RouteCollectionRow> rows;

  const RouteCollectionState({
    required this.loading,
    required this.filters,
    required this.routeCodes,
    required this.officers,
    required this.rows,
    this.error,
  });

  factory RouteCollectionState.initial() => RouteCollectionState(
    loading: false,
    error: null,
    filters: const RouteCollectionFilters(),
    routeCodes: const ["All", "R001", "R002", "R003", "R004"],
    officers: const ["All", "John Smith", "Sarah Johnson", "Michael Chen"],
    rows: const [],
  );

  RouteCollectionState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    RouteCollectionFilters? filters,
    List<String>? routeCodes,
    List<String>? officers,
    List<RouteCollectionRow>? rows,
  }) {
    return RouteCollectionState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      filters: filters ?? this.filters,
      routeCodes: routeCodes ?? this.routeCodes,
      officers: officers ?? this.officers,
      rows: rows ?? this.rows,
    );
  }
}

class RouteCollectionController extends StateNotifier<RouteCollectionState> {
  RouteCollectionController(this.ref) : super(RouteCollectionState.initial()) {
    load(); // initial load
  }

  final Ref ref;

  void setRouteCode(String value) {
    if (value == "All") {
      state = state.copyWith(
        filters: state.filters.copyWith(clearRouteCode: true),
        clearError: true,
      );
    } else {
      state = state.copyWith(
        filters: state.filters.copyWith(routeCode: value),
        clearError: true,
      );
    }
  }

  void setOfficer(String value) {
    if (value == "All") {
      state = state.copyWith(
        filters: state.filters.copyWith(clearOfficer: true),
        clearError: true,
      );
    } else {
      state = state.copyWith(
        filters: state.filters.copyWith(officer: value),
        clearError: true,
      );
    }
  }

  void setFrom(DateTime? d) {
    state = state.copyWith(
      filters: state.filters.copyWith(from: d),
      clearError: true,
    );
  }

  void setTo(DateTime? d) {
    state = state.copyWith(
      filters: state.filters.copyWith(to: d),
      clearError: true,
    );
  }

  Future<void> applyFilter() => load();

  Future<void> resetFilters() async {
    state = state.copyWith(
      filters: const RouteCollectionFilters(),
      clearError: true,
    );
    await load();
  }

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);

    try {
      // TODO: Replace with API call using:
      // state.filters.routeCode, state.filters.officer, state.filters.from, state.filters.to
      await Future.delayed(const Duration(milliseconds: 450));

      final mock = <RouteCollectionRow>[
        RouteCollectionRow(
          routeCode: "R001",
          routeName: "Colombo Central",
          officer: "John Smith",
          totalCustomers: 45,
          totalCollected: 165015,
          collectionDate: DateTime(2024, 1, 21),
          status: CollectionStatus.completed,
        ),
        RouteCollectionRow(
          routeCode: "R002",
          routeName: "Galle Road",
          officer: "Sarah Johnson",
          totalCustomers: 38,
          totalCollected: 98540,
          collectionDate: DateTime(2024, 1, 21),
          status: CollectionStatus.partial,
        ),
        RouteCollectionRow(
          routeCode: "R003",
          routeName: "Kandy Main",
          officer: "Michael Chen",
          totalCustomers: 40,
          totalCollected: 0,
          collectionDate: DateTime(2024, 1, 21),
          status: CollectionStatus.noCollection,
        ),
        RouteCollectionRow(
          routeCode: "R004",
          routeName: "Negombo Beach",
          officer: "John Smith",
          totalCustomers: 52,
          totalCollected: 0,
          collectionDate: DateTime(2024, 1, 21),
          status: CollectionStatus.completed,
        ),
      ];

      final f = state.filters;

      bool inRange(DateTime d, DateTime? from, DateTime? to) {
        if (from != null &&
            d.isBefore(DateTime(from.year, from.month, from.day)))
          return false;
        if (to != null &&
            d.isAfter(DateTime(to.year, to.month, to.day, 23, 59, 59)))
          return false;
        return true;
      }

      final filtered = mock.where((r) {
        final okRoute = f.routeCode == null ? true : r.routeCode == f.routeCode;
        final okOfficer = f.officer == null ? true : r.officer == f.officer;
        final okDate = inRange(r.collectionDate, f.from, f.to);
        return okRoute && okOfficer && okDate;
      }).toList();

      state = state.copyWith(loading: false, rows: filtered);
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: "Failed to load route collections",
      );
    }
  }
}

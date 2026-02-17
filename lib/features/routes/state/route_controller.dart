import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../domain/route_models.dart';

final routeProvider = StateNotifierProvider<RouteController, RouteState>(
  (ref) => RouteController(ref),
);

class RouteState {
  final bool loading;
  final String? error;

  final RouteFilters filters;
  final List<RouteRowModel> rows;

  const RouteState({
    required this.loading,
    required this.filters,
    required this.rows,
    this.error,
  });

  factory RouteState.initial() =>
      const RouteState(loading: false, filters: RouteFilters(), rows: []);

  RouteState copyWith({
    bool? loading,
    String? error,
    bool clearError = false,
    RouteFilters? filters,
    List<RouteRowModel>? rows,
  }) {
    return RouteState(
      loading: loading ?? this.loading,
      error: clearError ? null : (error ?? this.error),
      filters: filters ?? this.filters,
      rows: rows ?? this.rows,
    );
  }
}

class RouteController extends StateNotifier<RouteState> {
  RouteController(this.ref) : super(RouteState.initial()) {
    load();
  }

  final Ref ref;

  void setSearchBy(RouteSearchBy v) {
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

  Future<void> applyFilter() => load();

  Future<void> load() async {
    state = state.copyWith(loading: true, clearError: true);
    try {
      // TODO: API call with state.filters.searchBy + state.filters.query
      await Future.delayed(const Duration(milliseconds: 450));

      final all = <RouteRowModel>[
        RouteRowModel(
          routeId: "1",
          routeCode: "R001",
          routeName: "Colombo Central",
          routeDescription:
              "Main commercial district including Fort and Pettah areas",
          officerName: "John Smith",
          date: DateTime(2024, 1, 21),
          status: "Completed",
        ),
        RouteRowModel(
          routeId: "2",
          routeCode: "R002",
          routeName: "Galle Road",
          routeDescription:
              "Coastal route covering main businesses and residential areas",
          officerName: "Sarah Johnson",
          date: DateTime(2024, 1, 21),
          status: "Partial",
        ),
        RouteRowModel(
          routeId: "3",
          routeCode: "R003",
          routeName: "Kandy Main",
          routeDescription: "Central province main collection route",
          officerName: null,
          date: DateTime(2024, 1, 21),
          status: "LKR 0",
        ),
        RouteRowModel(
          routeId: "4",
          routeCode: "R004",
          routeName: "Negombo Beach",
          routeDescription: "Tourist belt and surrounding areas",
          officerName: "John Smith",
          date: DateTime(2024, 1, 21),
          status: "Completed",
        ),
      ];

      final f = state.filters;
      final q = f.query.trim().toLowerCase();

      final filtered = all.where((r) {
        if (q.isEmpty) return true;

        switch (f.searchBy) {
          case RouteSearchBy.all:
            return r.routeCode.toLowerCase().contains(q) ||
                r.routeName.toLowerCase().contains(q) ||
                r.routeDescription.toLowerCase().contains(q);
          case RouteSearchBy.code:
            return r.routeCode.toLowerCase().contains(q);
          case RouteSearchBy.name:
            return r.routeName.toLowerCase().contains(q);
        }
      }).toList();

      state = state.copyWith(loading: false, rows: filtered);
    } catch (e) {
      state = state.copyWith(loading: false, error: "Failed to load routes");
    }
  }
}

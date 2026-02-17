enum CollectionStatus { completed, partial, noCollection }

class RouteCollectionFilters {
  final String? routeCode; // null => All
  final String? officer; // null => All
  final DateTime? from;
  final DateTime? to;

  const RouteCollectionFilters({
    this.routeCode,
    this.officer,
    this.from,
    this.to,
  });

  RouteCollectionFilters copyWith({
    String? routeCode,
    String? officer,
    DateTime? from,
    DateTime? to,
    bool clearRouteCode = false,
    bool clearOfficer = false,
    bool clearFrom = false,
    bool clearTo = false,
  }) {
    return RouteCollectionFilters(
      routeCode: clearRouteCode ? null : (routeCode ?? this.routeCode),
      officer: clearOfficer ? null : (officer ?? this.officer),
      from: clearFrom ? null : (from ?? this.from),
      to: clearTo ? null : (to ?? this.to),
    );
  }
}

class RouteCollectionRow {
  final String routeCode;
  final String routeName;
  final String officer;
  final int totalCustomers;
  final double totalCollected;
  final DateTime collectionDate;
  final CollectionStatus status;

  const RouteCollectionRow({
    required this.routeCode,
    required this.routeName,
    required this.officer,
    required this.totalCustomers,
    required this.totalCollected,
    required this.collectionDate,
    required this.status,
  });
}

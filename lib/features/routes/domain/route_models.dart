enum RouteSearchBy { all, code, name }

class RouteFilters {
  final RouteSearchBy searchBy;
  final String query;

  const RouteFilters({this.searchBy = RouteSearchBy.all, this.query = ""});

  RouteFilters copyWith({RouteSearchBy? searchBy, String? query}) {
    return RouteFilters(
      searchBy: searchBy ?? this.searchBy,
      query: query ?? this.query,
    );
  }
}

class RouteRowModel {
  final String routeId;
  final String routeCode;
  final String routeName;
  final String routeDescription;

  // Optional (to match your mobile cards)
  final String? officerName;
  final DateTime? date;
  final String? status; // "Completed" / "Partial" / "LKR 0"
  final bool showEdit;

  const RouteRowModel({
    required this.routeId,
    required this.routeCode,
    required this.routeName,
    required this.routeDescription,
    this.officerName,
    this.date,
    this.status,
    this.showEdit = true,
  });
}

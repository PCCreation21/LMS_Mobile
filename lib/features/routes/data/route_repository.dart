import '../../../core/networking/api_client.dart';
import '../../../core/networking/endpoints.dart';
import '../domain/route_models.dart';

class RouteRepository {
  final ApiClient _apiClient;

  RouteRepository(this._apiClient);

  Future<List<RouteRowModel>> getRoutes() async {
    final response = await _apiClient.get(ApiEndpoints.routes);
    return (response.data as List)
        .map((json) => RouteRowModel(
              routeId: json['id']?.toString() ?? '',
              routeCode: json['routeCode'] ?? '',
              routeName: json['routeName'] ?? '',
              routeDescription: json['routeDescription'] ?? '',
            ))
        .toList();
  }
}

import '../../../core/networking/api_client.dart';
import '../../../core/networking/endpoints.dart';
import '../domain/loan_package_models.dart';

class LoanPackageRepository {
  final ApiClient _apiClient;

  LoanPackageRepository(this._apiClient);

  Future<List<LoanPackageRowModel>> getLoanPackages() async {
    final response = await _apiClient.get(ApiEndpoints.loanPackages);
    return (response.data as List)
        .map((json) => LoanPackageRowModel.fromJson(json))
        .toList();
  }

  Future<List<LoanPackageRowModel>> searchByCode(String code) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.loanPackages}/code',
      queryParameters: {'search': code},
    );
    return (response.data as List)
        .map((json) => LoanPackageRowModel.fromJson(json))
        .toList();
  }

  Future<List<LoanPackageRowModel>> searchByName(String name) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.loanPackages}/name',
      queryParameters: {'search': name},
    );
    return (response.data as List)
        .map((json) => LoanPackageRowModel.fromJson(json))
        .toList();
  }

  Future<void> deleteLoanPackage(String packageCode) async {
    await _apiClient.delete(ApiEndpoints.loanPackageByCode(packageCode));
  }
}

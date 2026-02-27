import '../../../core/networking/api_client.dart';
import '../../../core/networking/endpoints.dart';
import '../domain/receipt_models.dart';

class ReceiptRepository {
  final ApiClient _apiClient;

  ReceiptRepository(this._apiClient);

  Future<ReceiptModel> getLoanReceipt(String loanNumber) async {
    final response = await _apiClient.get(ApiEndpoints.loanByNumber(loanNumber));
    return ReceiptModel.fromJson(response.data);
  }
}

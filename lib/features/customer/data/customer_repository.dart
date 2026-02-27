import 'package:dio/dio.dart';
import '../../../core/networking/api_client.dart';
import '../../../core/networking/endpoints.dart';
import '../domain/customer_models.dart';

class CustomerRepository {
  final ApiClient _apiClient;

  CustomerRepository(this._apiClient);

  Future<List<Customer>> getCustomers({String? search, String? routeCode, String? status}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search != null) queryParams['search'] = search;
      if (routeCode != null) queryParams['routeCode'] = routeCode;
      if (status != null) queryParams['status'] = status;

      final response = await _apiClient.get(
        ApiEndpoints.customers,
        queryParameters: queryParams.isEmpty ? null : queryParams,
      );

      final data = response.data;
      if (data is List) {
        return data.map((json) => _fromJson(json)).toList();
      }
      return [];
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Customer> updateCustomer(Customer customer) async {
    try {
      final response = await _apiClient.put(
        '/api/customers/${customer.id}',
        data: {
          'nic': customer.nic,
          'customerName': customer.name,
          'phoneNumber': customer.phone,
          'address': customer.address,
          'routeCode': customer.routeCode,
          'email': customer.email,
          'secondaryPhoneNumber': customer.secondaryPhone,
        },
      );
      return _fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Customer> createCustomer(CreateCustomerRequest request) async {
    try {
      final response = await _apiClient.post(
        ApiEndpoints.customers,
        data: {
          'nic': request.nic,
          'customerName': request.name,
          'phoneNumber': request.phone,
          'address': '${request.addressLine1}, ${request.street1}${request.street2 != null ? ', ${request.street2}' : ''}${request.street3 != null ? ', ${request.street3}' : ''}',
          'routeCode': request.routeCode,
          'email': request.email,
          'gender': request.gender.name.toUpperCase(),
          'secondaryPhoneNumber': request.secondaryPhone,
          'status': request.status.name.toUpperCase(),
        },
      );
      return _fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteCustomer(String id) async {
    try {
      await _apiClient.delete('/api/customers/$id');
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Customer _fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id']?.toString() ?? '',
      nic: json['nic'] ?? '',
      name: json['customerName'] ?? '',
      phone: json['phoneNumber'] ?? '',
      secondaryPhone: json['secondaryPhoneNumber'],
      address: json['address'] ?? '',
      email: json['email'],
      gender: _parseGender(json['gender']),
      routeCode: json['routeCode'] ?? '',
      createdDate: DateTime.tryParse(json['createdDate'] ?? '') ?? DateTime.now(),
      status: _parseStatus(json['status']),
      loanNumbers: [],
    );
  }

  Gender _parseGender(String? value) {
    if (value == null) return Gender.other;
    switch (value.toLowerCase()) {
      case 'male':
        return Gender.male;
      case 'female':
        return Gender.female;
      default:
        return Gender.other;
    }
  }

  CustomerStatus _parseStatus(String? value) {
    if (value == null) return CustomerStatus.active;
    return value.toLowerCase() == 'active' ? CustomerStatus.active : CustomerStatus.inactive;
  }

  String _handleError(DioException e) {
    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map && data.containsKey('message')) {
        return data['message'];
      }
      return 'Server error: ${e.response!.statusCode}';
    }
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Connection timeout';
    }
    if (e.type == DioExceptionType.connectionError) {
      return 'Cannot connect to server';
    }
    return 'An unexpected error occurred';
  }
}

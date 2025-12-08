import 'package:dio/dio.dart';
import 'api_client.dart';

class ProductService {
  final ApiClient _apiClient = ApiClient();

  // Get all products (public - no auth required)
  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await _apiClient.dio.get('/products');

      return {
        'success': true,
        'products': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get single product detail
  Future<Map<String, dynamic>> getProduct(int productId) async {
    try {
      final response = await _apiClient.dio.get('/products/$productId');

      return {
        'success': true,
        'product': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Map<String, dynamic> _handleError(DioException e) {
    String message = 'An error occurred';

    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          message = errors.values.first[0] ?? message;
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout';
    } else if (e.type == DioExceptionType.unknown) {
      message = 'No internet connection';
    }

    return {'success': false, 'message': message};
  }
}

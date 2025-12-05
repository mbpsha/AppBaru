import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class OrderService {
  final ApiClient _apiClient = ApiClient();

  // Get all orders
  Future<Map<String, dynamic>> getOrders() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.orders);

      return {'success': true, 'orders': response.data['orders'] ?? []};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get order detail
  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.orderDetail(orderId));

      return {'success': true, 'order': response.data['order']};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Create order
  Future<Map<String, dynamic>> createOrder({
    required int productId,
    required int quantity,
    required String recipientName,
    required String recipientPhone,
    required String address,
    required int cityId,
    required String courier,
    required int shippingCost,
    String? notes,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.orders,
        data: {
          'id_produk': productId,
          'kuantitas': quantity,
          'nama_penerima': recipientName,
          'no_telepon_penerima': recipientPhone,
          'alamat_pengiriman': address,
          'id_kota': cityId,
          'kurir': courier,
          'ongkos_kirim': shippingCost,
          'catatan': notes,
        },
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Order created successfully',
        'order': response.data['order'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Error handler
  Map<String, dynamic> _handleError(DioException e) {
    String message = 'An error occurred';

    if (e.response != null) {
      final data = e.response!.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;

        // Handle validation errors
        if (data['errors'] != null) {
          final errors = data['errors'] as Map<String, dynamic>;
          final errorMessages = errors.values
              .expand((e) => e is List ? e : [e])
              .join(', ');
          message = errorMessages;
        }
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      message = 'Connection timeout';
    } else if (e.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    return {'success': false, 'message': message, 'error': e.message};
  }
}

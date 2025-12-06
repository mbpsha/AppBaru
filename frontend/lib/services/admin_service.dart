import 'package:dio/dio.dart';
import 'api_client.dart';

class AdminService {
  final ApiClient _apiClient = ApiClient();

  // ============================================
  // PRODUCT MANAGEMENT
  // ============================================

  // Get all products
  Future<Map<String, dynamic>> getProducts() async {
    try {
      final response = await _apiClient.dio.get('/api/admin/products');

      return {
        'success': true,
        'products': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Create product
  Future<Map<String, dynamic>> createProduct({
    required String namaProduk,
    required String deskripsi,
    required int harga,
    required int stok,
    String? gambar,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/api/admin/products',
        data: {
          'nama_produk': namaProduk,
          'deskripsi': deskripsi,
          'harga': harga,
          'stok': stok,
          'gambar': gambar,
        },
      );

      return {
        'success': true,
        'message': 'Product created successfully',
        'product': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Update product
  Future<Map<String, dynamic>> updateProduct({
    required int productId,
    required String namaProduk,
    required String deskripsi,
    required int harga,
    required int stok,
    String? gambar,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/admin/products/$productId',
        data: {
          'nama_produk': namaProduk,
          'deskripsi': deskripsi,
          'harga': harga,
          'stok': stok,
          'gambar': gambar,
        },
      );

      return {
        'success': true,
        'message': 'Product updated successfully',
        'product': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Delete product
  Future<Map<String, dynamic>> deleteProduct(int productId) async {
    try {
      await _apiClient.dio.delete('/api/admin/products/$productId');

      return {'success': true, 'message': 'Product deleted successfully'};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============================================
  // ORDER MANAGEMENT
  // ============================================

  // Get all orders
  Future<Map<String, dynamic>> getOrders() async {
    try {
      final response = await _apiClient.dio.get('/api/admin/orders');

      return {
        'success': true,
        'orders': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get order detail
  Future<Map<String, dynamic>> getOrderDetail(int orderId) async {
    try {
      final response = await _apiClient.dio.get('/api/admin/orders/$orderId');

      return {'success': true, 'order': response.data['data'] ?? response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Update order status
  Future<Map<String, dynamic>> updateOrderStatus({
    required int orderId,
    required String status,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/admin/orders/$orderId/status',
        data: {'status': status},
      );

      return {
        'success': true,
        'message': 'Order status updated successfully',
        'order': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============================================
  // PAYMENT VERIFICATION
  // ============================================

  // Verify payment
  Future<Map<String, dynamic>> verifyPayment({
    required int paymentId,
    required String status, // 'verified' or 'rejected'
  }) async {
    try {
      final response = await _apiClient.dio.put(
        '/api/admin/payments/$paymentId/verify',
        data: {'status': status},
      );

      return {
        'success': true,
        'message': 'Payment verification updated successfully',
        'payment': response.data['data'] ?? response.data,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // ============================================
  // ERROR HANDLER
  // ============================================

  Map<String, dynamic> _handleError(DioException e) {
    String message = 'An error occurred';

    if (e.response != null) {
      // Server responded with error
      final data = e.response!.data;

      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;

        // Handle validation errors
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

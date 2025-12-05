import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class CartService {
  final ApiClient _apiClient = ApiClient();

  // Get cart items
  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _apiClient.dio.get(ApiConfig.cart);

      return {
        'success': true,
        'cart': response.data['keranjang'],
        'items': response.data['items'] ?? [],
        'total': response.data['total'] ?? 0,
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Add item to cart
  Future<Map<String, dynamic>> addToCart({
    required int productId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        ApiConfig.cart,
        data: {'id_produk': productId, 'kuantitas': quantity},
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Item added to cart',
        'cart': response.data['keranjang'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Update cart item quantity
  Future<Map<String, dynamic>> updateCartItem({
    required int detailId,
    required int quantity,
  }) async {
    try {
      final response = await _apiClient.dio.put(
        ApiConfig.cartDetail(detailId),
        data: {'kuantitas': quantity},
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Cart updated',
        'item': response.data['detail'],
      };
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Remove item from cart
  Future<Map<String, dynamic>> removeFromCart(int detailId) async {
    try {
      final response = await _apiClient.dio.delete(
        ApiConfig.cartDetail(detailId),
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Item removed from cart',
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

import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class PaymentService {
  final ApiClient _apiClient = ApiClient();

  // Submit payment confirmation
  Future<Map<String, dynamic>> submitPayment({
    required int orderId,
    required String accountNumber,
    required String accountName,
    required int amount,
    required String transferDate,
    String? proofImage, // Base64 encoded image or URL
  }) async {
    try {
      final data = {
        'id_pesanan': orderId,
        'no_rekening': accountNumber,
        'nama_rekening': accountName,
        'jumlah_transfer': amount,
        'tanggal_transfer': transferDate,
      };

      if (proofImage != null) {
        data['bukti_transfer'] = proofImage;
      }

      final response = await _apiClient.dio.post(
        ApiConfig.payments,
        data: data,
      );

      return {
        'success': true,
        'message': response.data['message'] ?? 'Payment submitted successfully',
        'payment': response.data['pembayaran'],
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

import 'package:dio/dio.dart';
import 'api_client.dart';

class NewsService {
  final ApiClient _apiClient = ApiClient();

  // Get all news (public - no auth required)
  Future<Map<String, dynamic>> getAllNews() async {
    try {
      final response = await _apiClient.dio.get('/news');

      return {'success': true, 'news': response.data['data'] ?? response.data};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Get single news detail
  Future<Map<String, dynamic>> getNews(int newsId) async {
    try {
      final response = await _apiClient.dio.get('/news/$newsId');

      return {'success': true, 'news': response.data['data'] ?? response.data};
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

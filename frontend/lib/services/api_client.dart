import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late Dio _dio;
  String? _token;

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.apiBaseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );

    // Add interceptors
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add token to headers if available
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }

          print('REQUEST[${options.method}] => PATH: ${options.path}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print(
            'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
          );
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print(
            'ERROR[${e.response?.statusCode}] => PATH: ${e.requestOptions.path}',
          );
          print('ERROR MESSAGE: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  Dio get dio => _dio;

  // Set token for authenticated requests
  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Get token from storage
  Future<String?> getToken() async {
    if (_token != null) return _token;

    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    return _token;
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  // Initialize token on app start
  Future<void> init() async {
    await getToken();
  }
}

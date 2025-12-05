class ApiConfig {
  // Base URL Laravel Backend
  static const String baseUrl = 'http://localhost:8000';
  static const String apiBaseUrl = '$baseUrl/api';

  // API Endpoints
  static const String login = '/login';
  static const String register = '/register';
  static const String logout = '/logout';
  static const String user = '/user';
  static const String profile = '/profile';

  // Cart Endpoints
  static const String cart = '/cart';
  static String cartDetail(int id) => '/cart/detail/$id';

  // Checkout Endpoints
  static String checkout(int productId) => '/checkout/$productId';
  static String checkoutAddress(int productId) =>
      '/checkout/$productId/address';

  // Order Endpoints
  static const String orders = '/orders';
  static String orderDetail(int id) => '/orders/$id';

  // Payment Endpoints
  static const String payments = '/payments';

  // RajaOngkir
  static const String rajaOngkirCost = '/rajaongkir/cost';

  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

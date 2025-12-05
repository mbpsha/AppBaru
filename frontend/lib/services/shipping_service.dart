import 'package:dio/dio.dart';
import '../config/api_config.dart';
import 'api_client.dart';

class ShippingService {
  final ApiClient _apiClient = ApiClient();

  // Calculate shipping cost
  Future<Map<String, dynamic>> calculateShippingCost({
    required int destinationCityId,
    required int weight,
    required String courier,
    int? originCityId,
  }) async {
    try {
      final data = {
        'destination': destinationCityId,
        'weight': weight,
        'courier': courier,
      };

      if (originCityId != null) {
        data['origin'] = originCityId;
      }

      final response = await _apiClient.dio.post(
        ApiConfig.rajaOngkirCost,
        data: data,
      );

      // Parse RajaOngkir response
      final rajaongkir = response.data['rajaongkir'];
      final results = rajaongkir['results'] as List;

      if (results.isEmpty) {
        return {'success': false, 'message': 'No shipping options available'};
      }

      // Extract shipping options
      final courierData = results[0];
      final costs = courierData['costs'] as List;

      final shippingOptions = costs.map((cost) {
        final costData = (cost['cost'] as List)[0];
        return {
          'service': cost['service'],
          'description': cost['description'],
          'cost': costData['value'],
          'etd': costData['etd'],
          'courier': courierData['code'],
          'courierName': courierData['name'],
        };
      }).toList();

      return {'success': true, 'options': shippingOptions};
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  // Error handler
  Map<String, dynamic> _handleError(DioException e) {
    String message = 'Failed to calculate shipping cost';

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

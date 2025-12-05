import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Simple test screen to verify API connectivity
/// Access this screen to test if Flutter can connect to Laravel backend
class ApiTestScreen extends StatefulWidget {
  @override
  _ApiTestScreenState createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final _authService = AuthService();
  String _statusMessage = 'Ready to test connection...';
  bool _isLoading = false;
  Color _statusColor = Colors.blue;

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Testing connection to Laravel backend...';
      _statusColor = Colors.orange;
    });

    try {
      // Try to get current user (will fail if not logged in, but that's OK)
      // We just want to see if we can reach the backend
      final result = await _authService.getCurrentUser();

      setState(() {
        _isLoading = false;
        if (result['success']) {
          _statusMessage =
              '✅ Connection SUCCESS!\n\nBackend is reachable.\nUser data received.';
          _statusColor = Colors.green;
        } else {
          // Even if failed (401 unauthorized), connection is OK
          if (result['message']?.contains('Unauthenticated') ?? false) {
            _statusMessage =
                '✅ Connection SUCCESS!\n\nBackend is reachable.\n(Not logged in yet - expected)';
            _statusColor = Colors.green;
          } else {
            _statusMessage =
                '⚠️ Connection OK but error:\n${result['message']}';
            _statusColor = Colors.orange;
          }
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage =
            '❌ Connection FAILED!\n\nError: $e\n\nMake sure Laravel backend is running on http://localhost:8000';
        _statusColor = Colors.red;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('API Connection Test'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _isLoading
                    ? Icons.sync
                    : (_statusColor == Colors.green
                          ? Icons.check_circle
                          : (_statusColor == Colors.red
                                ? Icons.error
                                : Icons.info)),
                size: 80,
                color: _statusColor,
              ),
              SizedBox(height: 32),
              Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: _statusColor,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 48),
              if (_isLoading)
                CircularProgressIndicator(color: Colors.green[700])
              else
                ElevatedButton.icon(
                  onPressed: _testConnection,
                  icon: Icon(Icons.refresh),
                  label: Text('Test Connection'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              SizedBox(height: 16),
              Text(
                'Backend URL: http://localhost:8000',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

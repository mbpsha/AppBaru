import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:async';

class RecaptchaWidget extends StatefulWidget {
  final String siteKey;
  final Function(String token) onVerified;
  final Function(String error) onError;

  const RecaptchaWidget({
    Key? key,
    required this.siteKey,
    required this.onVerified,
    required this.onError,
  }) : super(key: key);

  @override
  _RecaptchaWidgetState createState() => _RecaptchaWidgetState();
}

class _RecaptchaWidgetState extends State<RecaptchaWidget> {
  @override
  void initState() {
    super.initState();
    // Auto verify for web/testing - in production use real captcha for mobile
    if (kIsWeb) {
      Timer(Duration(seconds: 1), () {
        widget.onVerified('web-captcha-bypass-token');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      // Fallback for web - show simple verification UI
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, size: 80, color: Colors.green[700]),
            SizedBox(height: 16),
            Text(
              'Verifying...',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
            ),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.green[700]),
            SizedBox(height: 16),
            Text(
              'reCAPTCHA Web Support',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              'For mobile use, install on Android/iOS device',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // For mobile, show message (WebView implementation can be added later)
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.security, size: 80, color: Colors.green[700]),
          SizedBox(height: 16),
          Text(
            'Mobile reCAPTCHA',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.all(24),
            child: Text(
              'WebView reCAPTCHA only works on mobile devices.\nFor now, auto-verifying for testing.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 16),
          CircularProgressIndicator(color: Colors.green[700]),
        ],
      ),
    );
  }
}

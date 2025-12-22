// Test file to verify image loading
// Run this in DartPad or as a simple Flutter test

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Image Test')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Testing image from backend:'),
              const SizedBox(height: 20),
              // Direct URL test
              Image.network(
                'http://localhost:8000/storage/products/product_1766368532_6948a5148dd2d.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const CircularProgressIndicator();
                },
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading image: $error');
                  print('Stack trace: $stackTrace');
                  return Column(
                    children: [
                      const Icon(Icons.error, size: 50, color: Colors.red),
                      Text('Error: $error'),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa.dart';
import 'package:flutter_2fa/flutter_2fa_config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const Scaffold(body: MyHome()),
    );
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  // Example of v1.0.5 configuration with customized theme and options enabled
  static final _2faConfig = Flutter2FAConfig(
    useSecureStorage: false, // Set to true to store keys securely in Keychain/Keystore
    allowBiometrics: true,   // Enables Face ID/Touch ID/Fingerprint fallback
    totpInterval: 30,
    totpDigits: 6,
    totpAlgorithm: 'SHA1',
    backgroundColor: Colors.grey[50],
    textColor: Colors.indigo[900],
    appBarColor: Colors.indigo,
    appBarTitleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    primaryButtonStyle: ElevatedButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    secondaryButtonStyle: TextButton.styleFrom(
      foregroundColor: Colors.indigo,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Flutter 2FA Demo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.indigo),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Flutter2FA().activate(
                  context: context,
                  appName: "Flutter 2FA Demo App",
                  email: "user@example.com",
                  config: _2faConfig, // Pass v1.0.5 config
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo, foregroundColor: Colors.white),
                child: const Text('Setup / Activate 2FA'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () => Flutter2FA().verify(
                  context: context,
                  page: const Success(),
                  config: _2faConfig, // Pass v1.0.5 config
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Login / Verify with 2FA'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Success')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_outline, size: 100, color: Colors.green),
            const SizedBox(height: 16),
            const Text(
              "User Authenticated Successfully!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Demo Home'),
            ),
          ],
        ),
      ),
    );
  }
}

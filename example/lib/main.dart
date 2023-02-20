import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa.dart';

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
    return const MaterialApp(home: Scaffold(body: MyHome()));
  }
}

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Flutter2FA().activate(
                        context: context,
                        appName: "Flutter 2FA",
                        email: "hipheckt@xyz.com"),
                    child: const Text('Activate 2FA'),
                  )),
              const SizedBox(height: 30),
              SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => Flutter2FA().verify(
                        context: context,
                        page: const Scaffold(
                          body: Center(
                              child: Text("user logged In Successfully!")),
                        )),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: const Text('Login with 2FA'),
                  ))
            ],
          )),
    );
  }
}

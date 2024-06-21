import 'package:flutter/material.dart';
import 'package:flutter_2fa/screens/generate_code.dart';
import 'package:flutter_2fa/screens/verify_code.dart';

class Flutter2FA {
  Future<void> activate(
      {required BuildContext context,
      required String appName,
      required String email}) {
    return Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => GenerateCode(appName: appName, email: email)),
    );
  }

  Future<void> verify({required BuildContext context, required page}) {
    return Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => VerifyCode(successPage: page)),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa_config.dart';
import 'package:flutter_2fa/screens/generate_code.dart';
import 'package:flutter_2fa/screens/verify_code.dart';

class Flutter2FA {
  Future<void> activate({
    required BuildContext context,
    required String appName,
    required String email,
    Flutter2FAConfig config = const Flutter2FAConfig(),
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GenerateCode(
          appName: appName,
          email: email,
          config: config,
        ),
      ),
    );
  }

  Future<void> verify({
    required BuildContext context,
    required Widget page,
    Flutter2FAConfig config = const Flutter2FAConfig(),
  }) {
    return Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VerifyCode(
          successPage: page,
          config: config,
        ),
      ),
    );
  }
}

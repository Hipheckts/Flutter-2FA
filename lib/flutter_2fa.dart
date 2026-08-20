import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa_config.dart';
import 'package:flutter_2fa/screens/generate_code.dart';
import 'package:flutter_2fa/screens/verify_code.dart';

/// The primary class for integrating Two-Factor Authentication (2FA) in your Flutter app.
class Flutter2FA {
  /// Creates an instance of [Flutter2FA].
  const Flutter2FA();

  /// Starts the 2FA activation flow by pushing the [GenerateCode] screen.
  ///
  /// Requires a [context] to navigate, the [appName] representing the issuer,
  /// and the user's [email] identifier. You can optionally supply custom
  /// settings and styles via the [config] parameter.
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

  /// Pushes the [VerifyCode] screen to authenticate the user before redirecting.
  ///
  /// Upon successful verification of the OTP (or recovery code/biometrics),
  /// the app redirects to the specified [page]. Custom settings and themes
  /// can be passed through [config].
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

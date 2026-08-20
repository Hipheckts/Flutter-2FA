import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// Configuration options for Flutter 2FA v1.0.5
class Flutter2FAConfig {
  /// Whether to use secure encrypted storage (Keychain/Keystore) to store secrets.
  final bool useSecureStorage;

  /// Whether to enable biometric authentication (Face ID / Touch ID / fingerprint) for verification.
  final bool allowBiometrics;

  /// The time step interval for TOTP codes in seconds (default: 30).
  final int totpInterval;

  /// The length of TOTP verification codes (default: 6).
  final int totpDigits;

  /// The hashing algorithm used for TOTP code generation ('SHA1', 'SHA256', 'SHA512').
  final String totpAlgorithm;

  // Custom UI styling parameters
  final Color? backgroundColor;
  final Color? textColor;
  final Color? appBarColor;
  final TextStyle? appBarTitleStyle;
  final ButtonStyle? primaryButtonStyle;
  final ButtonStyle? secondaryButtonStyle;
  final TextStyle? primaryButtonTextStyle;
  final TextStyle? secondaryButtonTextStyle;
  final PinTheme? defaultPinTheme;
  final PinTheme? focusedPinTheme;
  final PinTheme? errorPinTheme;

  const Flutter2FAConfig({
    this.useSecureStorage = false,
    this.allowBiometrics = false,
    this.totpInterval = 30,
    this.totpDigits = 6,
    this.totpAlgorithm = 'SHA1',
    this.backgroundColor,
    this.textColor,
    this.appBarColor,
    this.appBarTitleStyle,
    this.primaryButtonStyle,
    this.secondaryButtonStyle,
    this.primaryButtonTextStyle,
    this.secondaryButtonTextStyle,
    this.defaultPinTheme,
    this.focusedPinTheme,
    this.errorPinTheme,
  });
}

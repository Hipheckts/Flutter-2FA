import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

/// Configuration options for Flutter 2FA v1.0.5.
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

  /// The background color for the 2FA configuration and verification screens.
  final Color? backgroundColor;

  /// The default text color used in the 2FA UI.
  final Color? textColor;

  /// The background color for the AppBar in the 2FA screens.
  final Color? appBarColor;

  /// The text style for the AppBar titles in the 2FA screens.
  final TextStyle? appBarTitleStyle;

  /// The button style for primary actions (e.g., "Complete Activation", "Verify Code").
  final ButtonStyle? primaryButtonStyle;

  /// The button style for secondary actions (e.g., "Copy All Codes", "Use a Recovery Code").
  final ButtonStyle? secondaryButtonStyle;

  /// The text style inside primary action buttons.
  final TextStyle? primaryButtonTextStyle;

  /// The text style inside secondary action buttons.
  final TextStyle? secondaryButtonTextStyle;

  /// The default pin input field theme for [Pinput].
  final PinTheme? defaultPinTheme;

  /// The pin input field theme for [Pinput] when a cell has focus.
  final PinTheme? focusedPinTheme;

  /// The pin input field theme for [Pinput] when validation fails.
  final PinTheme? errorPinTheme;

  /// Creates a custom [Flutter2FAConfig] instance.
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

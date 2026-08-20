# Flutter 2FA

🔐 A Flutter package to add secure Two-Factor Authentication (2FA) via time-based one-time passwords (TOTP) to any Flutter application with ease.

[![Pub Version](https://img.shields.io/pub/v/flutter_2fa?style=flat-square)](https://pub.dev/packages/flutter_2fa)
[![License](https://img.shields.io/github/license/Hipheckts/Flutter-2FA?style=flat-square)](https://github.com/Hipheckts/Flutter-2FA/blob/master/LICENSE)

---

## 📸 Screenshots

<p float="left">
  <img src="https://github.com/Hipheckts/Flutter-2FA/blob/master/sc_1.png?raw=true" width="180" alt="2FA Overview" style="margin-right: 10px;">
  <img src="https://github.com/Hipheckts/Flutter-2FA/blob/master/sc_2.png?raw=true" width="180" alt="Copy Key" style="margin-right: 10px;">
  <img src="https://github.com/Hipheckts/Flutter-2FA/blob/master/sc_3.png?raw=true" width="180" alt="Verify OTP" style="margin-right: 10px;">
  <img src="https://github.com/Hipheckts/Flutter-2FA/blob/master/sc_4.png?raw=true" width="180" alt="Success Feedback" style="margin-right: 10px;">
</p>

---

## ✨ Features (v1.0.5 Upgrade)

- **Quick Setup**: Generates a standard cryptographically secure TOTP secret key compatible with Google Authenticator, Microsoft Authenticator, Authy, etc.
- **QR Code Generation**: Integrated visual setup flow using dynamic QR codes.
- **Copy-to-Clipboard**: Fallback configuration flow allowing users to copy the raw setup key manually.
- **Secure OTP Verification**: Standard input interface using high-quality pin inputs (`pinput` integration).
- **🎨 Custom UI Themes**: Override background colors, text colors, AppBars, button styles, and PIN input decorations to match your app's design system.
- **🔒 Secure Storage**: Optional encrypted storage backend via `flutter_secure_storage` to secure secret keys and recovery codes.
- **🛡️ Biometric Authentication**: Quick local unlock (Face ID / Touch ID / Fingerprint) via `local_auth` integration.
- **🧩 Backup Recovery Codes**: Generates 10 static recovery codes during activation. Displayed under a space-saving collapsible accordion. Users can use these codes as a login fallback.
- **⚙️ Configurable TOTP Settings**: Configure digit length, intervals (e.g. 30s/60s), and hashing algorithms (SHA1, SHA256, SHA512).

---

## 📦 Installation & Dependency Upgrades

Add `flutter_2fa` and its required biometric and secure storage backend packages to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_2fa: ^1.0.5
  local_auth: ^2.3.0
  flutter_secure_storage: ^9.2.4
```

Or install them directly:

```bash
flutter pub add flutter_2fa local_auth flutter_secure_storage
```

> [!NOTE]  
> To support newer platform libraries and Dart 3.x, transitive dependency upgrades have been applied (specifically upgrading internal Windows helpers which removes deprecated `win32 3.1.3` conflicts).

### ⚙️ Android Toolchain Requirements

To compile successfully with newer dependency versions (e.g. Kotlin 2.x and Java 21), make sure your Android project files are configured as follows:

- **Gradle Wrapper**: Version `8.14.0` or higher (`gradle-wrapper.properties`).
- **Android Gradle Plugin (AGP)**: Version `8.11.1` or higher (`settings.gradle`).
- **Kotlin**: Version `2.2.20` or higher (`settings.gradle`).
- **Compile SDK**: Version `34` or higher (`app/build.gradle`).

---

## 🚀 Usage

### 1. Configure Options (New in v1.0.5)

Define a `Flutter2FAConfig` configuration object:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_2fa/flutter_2fa_config.dart';

final twoFactorConfig = Flutter2FAConfig(
  useSecureStorage: true,   // Encrypts stored secret keys in Keychain/Keystore
  allowBiometrics: true,    // Enables Face ID/Touch ID quick unlock
  totpInterval: 30,         // TOTP step interval (in seconds)
  totpDigits: 6,            // OTP digit length
  totpAlgorithm: 'SHA1',    // Hashing algorithm
  
  // Custom Styles
  backgroundColor: Colors.grey[50],
  textColor: Colors.indigo[900],
  appBarColor: Colors.indigo,
  primaryButtonStyle: ElevatedButton.styleFrom(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
  ),
);
```

### 2. Activating 2FA Setup Flow

Trigger the initialization UI screen where the user is shown the secret seed key, the setup QR code, and collapsible backup recovery codes.

```dart
import 'package:flutter_2fa/flutter_2fa.dart';

void activateTwoFactor(BuildContext context) async {
  await Flutter2FA().activate(
    context: context,
    appName: "Your App Name",       // App name shown in Authenticator app
    email: "user@example.com",     // User email identifier for the account
    config: twoFactorConfig,       // Pass the custom config
  );
}
```

### 3. Verifying a 2FA Login Session

Trigger the OTP input, biometric verification prompt, or backup recovery code input.

```dart
import 'package:flutter_2fa/flutter_2fa.dart';

void verifyTwoFactor(BuildContext context) async {
  await Flutter2FA().verify(
    context: context,
    page: const DashboardScreen(),  // Redirect target widget upon successful validation
    config: twoFactorConfig,       // Pass the custom config
  );
}
```

---

## 🛠️ Contribution

Contributions, issues, and feature requests are very welcome! Feel free to open a pull request or file an issue.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

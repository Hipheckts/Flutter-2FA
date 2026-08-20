import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:local_auth/local_auth.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter_2fa/flutter_2fa_config.dart';
import 'package:flutter_2fa/storage_helper.dart';

class VerifyCode extends StatefulWidget {
  final Widget successPage;
  final Flutter2FAConfig config;

  const VerifyCode({
    Key? key,
    required this.successPage,
    required this.config,
  }) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final codeController = TextEditingController();
  final recoveryController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  
  String secKey = '';
  bool isActive = false;
  bool showRecoveryInput = false;
  
  late final StorageHelper storage;
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    storage = StorageHelper(useSecure: widget.config.useSecureStorage);
    checkAndInit();
  }

  @override
  void dispose() {
    codeController.dispose();
    recoveryController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  Future<void> checkAndInit() async {
    isActive = await storage.readBool('activate2FA');
    final storedKey = await storage.readString('secKey');
    secKey = storedKey ?? '';
    setState(() {});

    if (isActive && widget.config.allowBiometrics) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics || await _localAuth.isDeviceSupported();
      if (!isAvailable) return;

      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to log in with 2FA',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (didAuthenticate) {
        _onVerificationSuccess();
      }
    } catch (e) {
      debugPrint('Biometric authentication failed: $e');
    }
  }

  void _onVerificationSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Verification successful!'),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => widget.successPage),
    );
  }

  void validateCode() {
    final code = codeController.text;
    
    // Determine algorithm
    Algorithm otpAlg = Algorithm.SHA1;
    if (widget.config.totpAlgorithm == 'SHA256') {
      otpAlg = Algorithm.SHA256;
    } else if (widget.config.totpAlgorithm == 'SHA512') {
      otpAlg = Algorithm.SHA512;
    }

    final generatedCode = OTP.generateTOTPCodeString(
      secKey,
      DateTime.now().millisecondsSinceEpoch,
      algorithm: otpAlg,
      interval: widget.config.totpInterval,
      length: widget.config.totpDigits,
      isGoogle: true,
    );

    if (code == generatedCode) {
      _onVerificationSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Code verification failed'),
        ),
      );
    }
  }

  Future<void> validateRecoveryCode() async {
    final code = recoveryController.text.trim();
    if (code.isEmpty) return;

    final isCorrect = await storage.useRecoveryCode(code);
    if (isCorrect) {
      _onVerificationSuccess();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Invalid recovery code'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(color: widget.config.textColor);

    final defaultPinTheme = widget.config.defaultPinTheme ?? PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(fontSize: 20, color: widget.config.textColor),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: widget.config.textColor?.withOpacity(0.3) ?? Colors.grey.withOpacity(0.5)),
      ),
    );

    final focusedPinTheme = widget.config.focusedPinTheme ?? defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: widget.config.textColor ?? Colors.indigo),
      ),
    );

    final errorPinTheme = widget.config.errorPinTheme ?? defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.redAccent),
      ),
    );

    return Scaffold(
      backgroundColor: widget.config.backgroundColor,
      appBar: AppBar(
        title: Text('Verify 2FA', style: widget.config.appBarTitleStyle),
        backgroundColor: widget.config.appBarColor,
        iconTheme: widget.config.textColor != null ? IconThemeData(color: widget.config.textColor) : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                if (!showRecoveryInput) ...[
                  Text(
                    'Enter Security Code',
                    style: theme.textTheme.titleMedium?.merge(textStyle).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the verification code generated by your Authenticator app.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.merge(textStyle),
                  ),
                  const SizedBox(height: 32),
                  Directionality(
                    textDirection: TextDirection.ltr,
                    child: Pinput(
                      length: widget.config.totpDigits,
                      controller: codeController,
                      focusNode: focusNode,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      errorPinTheme: errorPinTheme,
                      onCompleted: (pin) => validateCode(),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (widget.config.allowBiometrics) ...[
                    IconButton(
                      icon: const Icon(Icons.fingerprint, size: 48),
                      color: widget.config.textColor ?? theme.primaryColor,
                      onPressed: _authenticateWithBiometrics,
                    ),
                    Text(
                      'Use Biometrics',
                      style: theme.textTheme.bodySmall?.merge(textStyle),
                    ),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: validateCode,
                      style: widget.config.primaryButtonStyle,
                      child: Text('Verify Code', style: widget.config.primaryButtonTextStyle),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showRecoveryInput = true;
                      });
                    },
                    style: widget.config.secondaryButtonStyle,
                    child: Text(
                      'Use a Recovery Code',
                      style: widget.config.secondaryButtonTextStyle ?? TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ] else ...[
                  Text(
                    'Enter Recovery Code',
                    style: theme.textTheme.titleMedium?.merge(textStyle).copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter one of the backup recovery codes generated during activation.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.merge(textStyle),
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: recoveryController,
                    decoration: InputDecoration(
                      hintText: 'xxxx-xxxx-xxxx',
                      hintStyle: TextStyle(color: widget.config.textColor?.withOpacity(0.5)),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.config.textColor?.withOpacity(0.3) ?? Colors.grey)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: widget.config.textColor ?? Colors.black)),
                    ),
                    style: textStyle.copyWith(fontFamily: 'monospace'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: validateRecoveryCode,
                      style: widget.config.primaryButtonStyle,
                      child: Text('Verify Recovery Code', style: widget.config.primaryButtonTextStyle),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showRecoveryInput = false;
                      });
                    },
                    style: widget.config.secondaryButtonStyle,
                    child: Text(
                      'Back to App Verification',
                      style: widget.config.secondaryButtonTextStyle ?? TextStyle(color: theme.primaryColor),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: widget.config.secondaryButtonStyle,
                    child: Text(
                      'Cancel',
                      style: widget.config.secondaryButtonTextStyle ?? const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

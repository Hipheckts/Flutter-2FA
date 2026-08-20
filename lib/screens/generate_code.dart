import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';
import 'dart:math';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_2fa/flutter_2fa_config.dart';
import 'package:flutter_2fa/storage_helper.dart';

class GenerateCode extends StatefulWidget {
  final String appName;
  final String email;
  final Flutter2FAConfig config;

  const GenerateCode({
    Key? key,
    required this.appName,
    required this.email,
    required this.config,
  }) : super(key: key);

  @override
  State<GenerateCode> createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  String secKey = '';
  List<String> recoveryCodes = [];
  late final StorageHelper storage;

  @override
  void initState() {
    super.initState();
    storage = StorageHelper(useSecure: widget.config.useSecureStorage);
    generateCode();
  }

  void generateCode() {
    secKey = OTP.randomSecret();
    recoveryCodes = List.generate(10, (_) => _generateSingleRecoveryCode());
    setState(() {});
  }

  String _generateSingleRecoveryCode() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final rand = Random();
    final buffer = StringBuffer();
    for (var i = 0; i < 12; i++) {
      if (i == 4 || i == 8) buffer.write('-');
      buffer.write(chars[rand.nextInt(chars.length)]);
    }
    return buffer.toString();
  }

  Future<void> activate2FA(BuildContext context) async {
    await storage.writeString('secKey', secKey);
    await storage.writeBool('activate2FA', true);
    await storage.saveRecoveryCodes(recoveryCodes);

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text('2FA Activation Complete!'),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = TextStyle(color: widget.config.textColor);

    final String qrData = 'otpauth://totp/${widget.appName}:${widget.email}'
        '?secret=$secKey'
        '&issuer=${widget.appName}'
        '&period=${widget.config.totpInterval}'
        '&digits=${widget.config.totpDigits}'
        '&algorithm=${widget.config.totpAlgorithm}';

    return Scaffold(
      backgroundColor: widget.config.backgroundColor,
      appBar: AppBar(
        title: Text('Setup 2FA', style: widget.config.appBarTitleStyle),
        backgroundColor: widget.config.appBarColor,
        iconTheme: widget.config.textColor != null ? IconThemeData(color: widget.config.textColor) : null,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Scan QR Code',
                style: theme.textTheme.titleMedium?.merge(textStyle).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan this code in your Authenticator app (e.g. Google Authenticator).',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.merge(textStyle),
              ),
              const SizedBox(height: 16),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: QrImageView(
                    data: qrData,
                    version: QrVersions.auto,
                    size: 200,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                'Manual Secret Key',
                style: theme.textTheme.titleMedium?.merge(textStyle).copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: SelectableText(
                        secKey,
                        style: textStyle.copyWith(fontFamily: 'monospace', fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      color: widget.config.textColor,
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: secKey));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Secret key copied to clipboard')),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),
              Theme(
                data: theme.copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  title: Text(
                    'Backup Recovery Codes',
                    style: theme.textTheme.titleMedium?.merge(textStyle).copyWith(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Tap to expand and save codes',
                    style: theme.textTheme.bodySmall?.merge(textStyle).copyWith(color: widget.config.textColor?.withOpacity(0.6)),
                  ),
                  iconColor: widget.config.textColor,
                  collapsedIconColor: widget.config.textColor,
                  children: [
                    const SizedBox(height: 8),
                    Text(
                      'Save these codes in a safe place. They can be used to log in if you lose your authenticator device.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.merge(textStyle),
                    ),
                    const SizedBox(height: 16),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 3.5,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: recoveryCodes.length,
                      itemBuilder: (context, index) {
                        return Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            recoveryCodes[index],
                            style: textStyle.copyWith(fontFamily: 'monospace', fontSize: 13),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        final allCodes = recoveryCodes.join('\n');
                        Clipboard.setData(ClipboardData(text: allCodes));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('All recovery codes copied to clipboard')),
                        );
                      },
                      icon: const Icon(Icons.copy_all),
                      label: const Text('Copy All Codes'),
                      style: widget.config.secondaryButtonStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => showCupertinoDialog(
                    barrierDismissible: true,
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Activation'),
                      content: const Text(
                        'Ensure you have scanned the QR code or saved the secret key/recovery codes before proceeding.',
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('Proceed'),
                          onPressed: () => activate2FA(context),
                        ),
                      ],
                    ),
                  ),
                  style: widget.config.primaryButtonStyle,
                  child: Text(
                    'Complete Activation',
                    style: widget.config.primaryButtonTextStyle,
                  ),
                ),
              ),
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
    );
  }
}

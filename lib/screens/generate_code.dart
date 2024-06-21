import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:otp/otp.dart';
import 'package:bip39/bip39.dart' as bip39;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenerateCode extends StatefulWidget {
  final String appName;
  final String email;
  const GenerateCode({Key? key, required this.appName, required this.email})
      : super(key: key);

  @override
  State<GenerateCode> createState() => _GenerateCodeState();
}

class _GenerateCodeState extends State<GenerateCode> {
  String secKey = '';
  String recoveryPhrase = '';

  generateCode() {
    recoveryPhrase = bip39.generateMnemonic();
    secKey = OTP.randomSecret();
    setState(() {});
  }

  activate2FA(context) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('secKey', secKey);
    localStorage.setBool('activate2FA', true);
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          backgroundColor: Colors.green,
          content: Text('2FA Activation Complete!')),
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    generateCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Scan Code from Authenticator'),
        const SizedBox(height: 20),
        QrImage(
          data:
              'otpauth://totp/${widget.appName}:${widget.email}?secret=$secKey&issuer=${widget.appName}&algorithm=SHA1',
          version: QrVersions.auto,
          size: 260,
        ),
        const SizedBox(height: 20),
        const Divider(),
        Text(
          'Secret Key',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectableText(secKey),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: secKey));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('copied secret key!')),
                );
              },
              child: const Icon(Icons.copy),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Text(
          'Recovery Phrase',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: SelectableText(recoveryPhrase)),
            GestureDetector(
              onTap: () {
                Clipboard.setData(ClipboardData(text: recoveryPhrase));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('copied recovery phrase!')),
                );
              },
              child: const Icon(Icons.copy),
            ),
          ],
        ),
        const SizedBox(height: 30),
        Padding(
            padding: const EdgeInsets.all(35),
            child: Column(
              children: [
                SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => AlertDialog(
                                title: const Text('Confirm?'),
                                content: const Text(
                                    'Please ensure you have linked to a preferred Authenticator.'),
                                actions: <Widget>[
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Proceed'),
                                    onPressed: () => activate2FA(context),
                                  ),
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .labelLarge,
                                    ),
                                    child: const Text('Cancel'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              )),
                      child: const Text('Complete Activation'),
                    )),
                const SizedBox(height: 30),
                SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          Navigator.pop(context);
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        shadowColor: MaterialStateProperty.all<Color>(
                            Colors.transparent),
                        overlayColor: MaterialStateProperty.resolveWith(
                          (states) {
                            return states.contains(MaterialState.pressed)
                                ? Colors.red.withOpacity(0.1)
                                : null;
                          },
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ))
              ],
            )),
      ],
    ));
  }
}

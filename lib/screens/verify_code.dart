import 'package:flutter/material.dart';
import 'package:otp/otp.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';

class VerifyCode extends StatefulWidget {
  final Widget successPage;
  const VerifyCode({Key? key, required this.successPage}) : super(key: key);

  @override
  State<VerifyCode> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends State<VerifyCode> {
  final codeController = TextEditingController();
  final focusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  // final TextEditingController codeController = TextEditingController();
  String secKey = '';
  bool isActive = false;

  @override
  void dispose() {
    codeController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  check2FA() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    setState(() {
      isActive = localStorage.getBool('activate2FA')!;
    });
  }

  getUserKey() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    secKey = localStorage.getString('secKey')!;
  }

  validateCode() {
    final code = codeController.text;
    final generatedCode = OTP.generateTOTPCodeString(
        secKey, DateTime.now().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1, isGoogle: true);
    if (code == generatedCode) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text('Code verified'),
      ));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => widget.successPage));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.red,
        content: Text('Code verification failed'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    check2FA();
    getUserKey();
  }

  @override
  Widget build(BuildContext context) {
    const focusedBorderColor = Colors.black;

    const defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
        fontSize: 22,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.black),
        ),
      ),
    );

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35.0),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Enter Code from Authenticator'),
                const SizedBox(height: 30),
                Directionality(
                  textDirection: TextDirection.ltr,
                  child: Pinput(
                    length: 6,
                    controller: codeController,
                    focusNode: focusNode,
                    androidSmsAutofillMethod:
                        AndroidSmsAutofillMethod.smsUserConsentApi,
                    listenForMultipleSmsOnAndroid: true,
                    defaultPinTheme: defaultPinTheme,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      validateCode();
                    },
                    onChanged: (value) {},
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(
                      border: Border.all(color: Colors.redAccent),
                    ),
                  ),
                ),
                const SizedBox(height: 100),
                SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        focusNode.unfocus();
                        formKey.currentState!.validate();
                        validateCode();
                      },
                      child: const Text('Verify Code'),
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
            ),
          ),
        )
      ],
    ));
  }
}

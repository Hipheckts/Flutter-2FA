library flutter_2fa;

import 'package:flutter/material.dart';

enum Code {
  Empty,
  Generated,
  Enter,
}

class AuthScreen extends StatelessWidget {
  final Function onPressed;
  final Code code;

  const AuthScreen(this.code, {required this.onPressed})
      : assert(code != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    switch (code) {
      case Code.Empty:
        return Scaffold(
          body: Center(
            child: Column(children: []),
          ),
        );
      case Code.Generated:
        return Scaffold(
          body: Center(
            child: Column(children: []),
          ),
        );
      case Code.Enter:
        return Scaffold(
          body: Center(
            child: Column(children: []),
          ),
        );
    }
  }
}

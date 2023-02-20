# Flutter Mono

`** This is an unofficial SDK for flutter`

This package to helps adds 2 Factor Authentiation in any flutter project with ease.

## 📸 Screen Shots

<p float="left">
<img src="https://github.com/hipheckts/flutter_2fa/blob/main/sc_1.png?raw=true" width="200">
<img src="https://github.com/hipheckts/flutter_2fa/blob/main/sc_2.png?raw=true" width="200">
<img src="https://github.com/hipheckts/flutter_2fa/blob/main/sc_3.png?raw=true" width="200">
<img src="https://github.com/hipheckts/flutter_2fa/blob/main/sc_4.png?raw=true" width="200">
<img src="https://github.com/hipheckts/flutter_2fa/blob/main/sc_5.png?raw=true" width="200">
</p>

### 🚀 How to Use plugin

- Launch Flutter 2FA with activate method in any button/onpressed action

```dart
import 'package:flutter_2fa/flutter_2fa.dart';

  void launch() async {
       await Flutter2FA().activate(
                        context: context,
                        appName: "Flutter 2FA", // your app ame
                        email: "hipheckt@xyz.com" // email of user to authenticate
                        );
  }
```

- Verify user authentication

```dart
import 'package:flutter_2fa/flutter_2fa.dart';

     ...
        void verify() async {
            await Flutter2FA().verify(context: context);
        }
      ...

```

## ✨ Contribution

Lots of PR's would be needed to improve this plugin. So lots of suggestions and PRs are welcome.

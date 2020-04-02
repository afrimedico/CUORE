import 'package:ghala/profile/app.dart';
import 'package:ghala/screen/home.dart';
import 'package:ghala/profile/signin.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int mode;

  @override
  void initState() {
    super.initState();

    init();
  }

  Map<String, dynamic> user;

  init() async {
    // アプリ設定
    var app = await App.getApp();
    int now = DateTime.now().toUtc().millisecondsSinceEpoch;
    // 起動回数
    app["boot"] = app.putIfAbsent("boot", () => 0) + 1;
    // 最終起動時刻
    app.putIfAbsent("ts", () => now);
    await App.setApp(app);

    // プロファイル設定
    user = await App.getProfile();
    if (user['name'] == null) {
      setState(() {
        mode = 0;
      });
    } else {
      userId = user['id'];
      userName = user['name'];
      userEmail = user['email'];
      userImageUrl = user['image'];
      setState(() {
        mode = 2;
      });
      print(user);
    }
  }

  signIn() async {
    setState(() {
      mode = 1;
    });

    var result = await signInWithGoogle();
    if (result != null) {
      user.putIfAbsent('id', () => userId);
      user.putIfAbsent('name', () => userName);
      user.putIfAbsent('email', () => userEmail);
      user.putIfAbsent('image', () => userImageUrl);
      int now = DateTime.now().toUtc().millisecondsSinceEpoch;
      user.putIfAbsent("ts", () => now);
      await App.setProfile(user);
      setState(() {
        mode = 2;
      });
    } else {
      setState(() {
        mode = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mode == 2
          ? HomeScreen()
          : mode == 1
              ? Container(color: Colors.white)
              : Container(
                  color: Colors.white,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image(
                            image: AssetImage("assets/icons/unicorn.png"),
                            height: 100.0),
                        SizedBox(height: 50),
                        _signInButton(),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        signIn();
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/icons/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

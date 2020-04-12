import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:cuore/profile/login.dart';
import 'package:cuore/sl/message.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CUORE',
      theme: new ThemeData(
          // primaryColor: new Color(0xff075E54),
          accentColor: new Color(0xff25D366),
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          primaryIconTheme: IconThemeData(color: Colors.blue),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
          textTheme:
              TextTheme(title: TextStyle(color: Colors.black, fontSize: 16))),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'CUORE'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState(title: this.title);
}

class _MyHomePageState extends State<MyHomePage> {
  final String title;

  _MyHomePageState({this.title});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      localizationsDelegates: [
        const SLMessageDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale.fromSubtags(
            languageCode: 'en'), // English: UK/USA/Canada/Singapore/Australia
        const Locale.fromSubtags(languageCode: 'ja'), // Japanese
        const Locale.fromSubtags(languageCode: 'ko'), // Korea
        const Locale.fromSubtags(languageCode: 'zh'), // Chinese
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hans'), // simplified Chinese 'zh_Hans'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant'), // traditional Chinese 'zh_Hant'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'HK'), // traditional Chinese 'zh_Hant_HK'
        const Locale.fromSubtags(
            languageCode: 'zh',
            scriptCode: 'Hant',
            countryCode: 'TW'), // traditional Chinese 'zh_Hant_TW'
        const Locale.fromSubtags(languageCode: 'th'), // Thailand
        const Locale.fromSubtags(languageCode: 'ms'), // Malaysia
        const Locale.fromSubtags(languageCode: 'id'), // Indonesia
        const Locale.fromSubtags(languageCode: 'fil'), // Philippines
        const Locale.fromSubtags(languageCode: 'vi'), // Vietnam
        const Locale.fromSubtags(languageCode: 'fr'), // France
        const Locale.fromSubtags(languageCode: 'de'), // Germany
        const Locale.fromSubtags(languageCode: 'it'), // Italy
        const Locale.fromSubtags(languageCode: 'ru'), // Russia
        const Locale.fromSubtags(languageCode: 'es'), // Spain
        const Locale.fromSubtags(languageCode: 'sw'), // Swahiri
      ],
      title: this.title,
      theme: new ThemeData(
          // primaryColor: new Color(0xff075E54),
          accentColor: new Color(0xff25D366),
          primarySwatch: Colors.blue,
          primaryColor: Colors.white,
          primaryIconTheme: IconThemeData(color: Colors.blue),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
          textTheme:
              TextTheme(title: TextStyle(color: Colors.black, fontSize: 16))),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      // home: new CureGoHome(),
    );
  }
}

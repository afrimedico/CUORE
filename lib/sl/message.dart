import 'package:cuore/sl/asset.dart';
import 'package:flutter/material.dart';

class SLMessageDelegate extends LocalizationsDelegate {
  const SLMessageDelegate();

  @override
  bool isSupported(Locale locale) =>
      (['en', 'ja'].contains(locale.languageCode)) ||
      ((['zh'].contains(locale.languageCode)) &&
              (['HK', 'TW'].contains(locale.countryCode)) ||
          ((['zh'].contains(locale.languageCode)) &&
              (['Hans', 'Hant'].contains(locale.scriptCode))) ||
          ((['zh'].contains(locale.languageCode)) &&
              !(['HK', 'TW'].contains(locale.countryCode)))) ||
      true;

  @override
  Future<SLMessage> load(Locale locale) => SLMessage.load(locale);

  @override
  bool shouldReload(SLMessageDelegate old) => false;
}

class SLMessage {
  // ロケール
  static late Locale locale;

  // メッセージデータ
  static List<List<dynamic>>? message_data = null;

  static Future loadAsset() async {
    message_data = await SLAssetService.loadCsv('assets/data/message.csv');
  }

  static Future<SLMessage> load(Locale loc) async {
    locale = loc;
    return SLMessage();
  }

  static int getLocaleIndex(String? locale) {
    var id = 0;
    for (var m in message_data![0]) {
      if (locale == m) {
        return id;
      }
      id++;
    }
    return 1; // ja
  }

  static String getMessage(String? locale, String key) {
    // locale = 'ja';
    if (message_data != null) {
      var id = getLocaleIndex(locale);
      for (var m in message_data!) {
        if (m[0] == key && id < m.length) {
          String s = m[id];
          return s.replaceAll('\\n', '\n');
        }
      }
    }
    return key;
  }

  static String of(String key) {
    if (locale.languageCode == 'zh') {
      // Chinese
      if (locale.scriptCode == 'Hans') {
        // Chinese Simplified in General
        return getMessage(locale.scriptCode, key);        
      } else if (locale.scriptCode == 'Hant') {
        // Chinese Traditional
        return getMessage(locale.scriptCode, key);     
      } else if (['HK', 'TW'].contains(locale.countryCode)) {
        // Chinese Traditional
        if (locale.countryCode == 'TW') {
          // Chinese Traditional in Taiwan
          return getMessage(locale.countryCode, key);
        } else if (locale.countryCode == 'HK') {
          // Chinese Traditional in Hong Kong
          return getMessage(locale.countryCode, key);
        }
      } else {
        // Chinese Traditional in Others
        return getMessage(locale.scriptCode, key);
      }
    } else if (['en', 'ja'].contains(locale.languageCode)) {
      // English or Japanese
      return getMessage(locale.languageCode, key);
    } else {
      //Others (not Supported)
      return getMessage(locale.languageCode, key);
    }
    return key;
  }
}

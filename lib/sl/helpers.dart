import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class HelperFunction {
  Future sendSms(String text) async {
    print(text);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var url =
        'https://cuore-sms.azurewebsites.net/api/HttpTrigger1?code=QXl3PM41immtOYF6myeZPJgl6m7r6/0zacidKlkbcPhZDM3aGxS4EA==';
    try{
      final response = await http.post(Uri.parse(url),
          headers: headers, body: json.encode({"SmsInfo": text}));
      if (response != null && response.statusCode != null) {
        return response.statusCode;
      }
    }catch(e){
      print('DuongTuan: $e');
      return 0;
    }
  }

  Future checkDeviceNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // Navigator.of(context).popUntil((route) => route.isFirst);
        return true;
      }
      return false;
    } on SocketException catch (_) {
      return false;
    }
  }
}

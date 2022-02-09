import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class RequestAssistance {
  //If request valid, returns the object that was requested
  static Future<dynamic> getRequest(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        var decodeData = convert.jsonDecode(jsonData);
        return decodeData;
      } else {
        return "Failed, No response!";
      }
    } catch (exp) {
      return "Failed";
    }
  }
}

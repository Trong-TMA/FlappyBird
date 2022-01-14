import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class APIServices{
  /*static String Url = 'https://localhost:44355/Api/highestscore' as Uri;*/

  static Future getData() async {
    // 4
    Response response = await get(Uri.parse('https://localhost:44355/Api/highestscore'));
    // 5
    if (response.statusCode == 200) {
      // 6
      return response.body;
    } else {
      print(response.statusCode);
    }
  }
}
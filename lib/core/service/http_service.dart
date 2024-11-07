import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../utils/methodes.dart';

class HttpService {
  static Future<Response?> getRequest(String url,
      {Map<String, String>? headers}) async {
    headers ??= {
      'User-Agent':
          'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.5735.199 Safari/537.36 Edg/114.0.1823.79',
    };
    try {
      Response response = await http.get(Uri.parse(url), headers: headers);
      if (response.statusCode == 200) {
        return response;
      } else {
        logger('statusCode = ${response.statusCode}');
      }
    } catch (e) {
      logger('Error : $e');
    }
    return null;
  }
}

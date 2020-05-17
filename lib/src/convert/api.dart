import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../site.dart';

class Api {
  static Future<Map> login(dynamic map) async {
    final client = new http.Client();
    final Map<String,String> request = {
        'token': Site.token,
        'session': Site.session,
        'type': map['type'],
        'idtoken': map['token'],
      };
    final response = await client.post(
      Site.api + 'login',
      headers: {'user-agent': 'ifelse.co-'+Site.version},
      body: request
    );
    try {
      if (response.statusCode == 200) {
        return json.decode(response.body).cast<Map<String, dynamic>>();   
      } else {
      Site.log.w(request);
        throw Exception("No Internet Connection.\nPlease Retry");
      }
    } catch (e) {
      Site.log.e(request);
      throw Exception(e.toString());
    }
  }
}
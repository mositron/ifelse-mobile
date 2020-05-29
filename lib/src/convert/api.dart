import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../site.dart';
import '../my.dart';
import 'util.dart';
import 'session.dart';

class Api {
  static Future<Map> call(String method, [Map<String,String> map]) async {
    final client = new http.Client();
    Map<String,String> request = {
        'token': Site.token,
        'session': My.session,
      };
    if(map != null) {
      request.addAll(map);
    }
    final response = await client.post(
      Site.api + method,
      headers: {'user-agent': 'ifelse.co-' + Site.version},
      body: request
    );
    //print(request);
    try {
      if (response.statusCode == 200) {
        Map<String, dynamic> resp = json.decode(response.body);
        getMy(resp, method);
        return resp;
      } else if (response.statusCode == 401) {
        print('api - 401 - ' + Site.api + method);
        return null;
      } else if (response.statusCode == 402) {
        print('api - 402 - ' + Site.api + method);
        return null;
      } else if (response.statusCode == 403) {
        print('api - 403 - ' + Site.api + method);
        return null;
      } else if (response.statusCode == 404) {
        print('api - 404 - ' + Site.api + method);
        return null;
      } else {
        print(request);
        return null;
      }
    } catch (e) {
      print(response.statusCode);
      print(e);
      print(response.body);
      return null;
    }
  }

  static Future<bool> load() async {
    final response = await call('load');
    if((response != null) && (response is Map) && (response['site'] is Map)) {
      Site.setData(response['site']);
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> login(dynamic map) async {
    final response = await call('login', {'type': map['type'], 'idtoken': map['idtoken']});
    if((response != null) && (response is Map)) {
      return true;
    } else {
      return false;
    }
  }

  static void getMy(Map<String, dynamic> resp, String method) async {
    if((resp['session'] != null) && (resp['session'] is String)) {
      String session = resp['session'].toString();
      if(session.length > 0) {
        List<String> split = session.split('.');
        if(split.length == 2) {
          String token = split[0].toString();
          token = token.replaceAll('-', '+').replaceAll('_', '/');
          final data = json.decode(utf8.decode(base64.decode(token)));
          if((data != null) && (data is Map)) {
            int id = getInt(data['id']);
            if(id > 0) {
              if((id != My.id) || (method == 'profile')) {
                sessionWrite(session);
              }
              My.id = id;
              My.firstName = data['firstname'].toString();
              My.lastName = data['lastname'].toString();
              My.name = My.firstName + ' ' + My.lastName;
              My.email = data['email'].toString();
              My.image = data['image'].toString();
              My.session = session;
              return;
            }
          }
        }
      }
    }
    My.id = 0;
  }
}
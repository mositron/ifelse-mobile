import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> cacheGetTemplate(String key) async {
  //Site.log.i('get - ' + key);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String val = prefs.getString(key);
  if((val != null) && (val is String)) {    
    dynamic data = json.decode(val);
    //Site.log.w(data);
    return data;
  }
  return null;
}

void cacheSaveTemplate(String key, dynamic data) async {
  //Site.log.i('save - ' + key);
  if((data != null) && (data is List)) {    
    String val = json.encode(data);
    if((val != null) && (val is String)) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, val);
      //Site.log.w('saved');
    }
  }
}
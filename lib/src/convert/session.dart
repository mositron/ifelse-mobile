import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../my.dart';
import '../site.dart';

void sessionLoad() async {
  final storage = FlutterSecureStorage();
  String session = await storage.read(key: 'if-session');
  if ((session != null) && (session.length > 0)) {
    My.session = session;
  }
}

void sessionWrite(String session) async {
  final storage = FlutterSecureStorage();
  await storage.write(key: 'if-session', value: session);
}

void sessionDelete() async {
  My.id = 0;
  My.session = '';
  final storage = FlutterSecureStorage();
  await storage.delete(key: 'if-session');
}

Future keyLoad() async {
  final storage = FlutterSecureStorage();
  String session = await storage.read(key: 'if-key');
  print(session);
  if ((session != null) && (session.length > 0)) {
    Site.ifKey = session;
  }
  print("read key - " + Site.ifKey);
}

void keyWrite(String session) async {
  final storage = FlutterSecureStorage();
  print("white key - " + session);
  await storage.write(key: 'if-key', value: session);
}

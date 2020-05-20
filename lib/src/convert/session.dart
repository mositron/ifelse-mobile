
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../my.dart';
import '../site.dart';

void sessionLoad() async {
  final storage = FlutterSecureStorage();
  String session = await storage.read(key: 'if-session');
  if((session != null) && (session.length > 0)) {
    My.session = session;
    Site.log.i(session);
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
import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class JobsPage extends StatefulWidget {
  final Map<String, dynamic> par;
  JobsPage({Key key, this.par}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState(par);
  }
}

class LoginState extends State<JobsPage> {
  bool loaded;
  Map<String, dynamic> par;
  LoginState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> request = {
      'order': '',
      'skip': '0'
    };
    request['text'] = 'ตำแหน่งงาน';

    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {
        return Layer.buildContent('jobs', context, request);
      }
    );
  }
}
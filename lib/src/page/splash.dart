import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'dart:async';
import 'dart:convert';
import '../site.dart';
import '../page/home.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashPage> {
  static final log = Logger();
  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    String message = '';
    if(await Api.load()) {  
      return Timer(Duration(seconds: 1),() {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } else {
      message = 'รหัส Token ไม่ถูกต้อง';
    }
    await IfDialog.show(context: context, text: message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(      
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFFFFFFF),Color(0xFFDDDDDD),]
        )
      ),    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/splash-logo.png'),
          SizedBox(
            height: 50.0,
          ),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ]
      )
    );
  }
}

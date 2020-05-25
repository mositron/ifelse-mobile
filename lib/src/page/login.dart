import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../site.dart';
import '../layer.dart';
import '../page/home.dart';
import '../convert/dialog.dart';
import '../convert/api.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: MyPagefulWidget(), debugShowCheckedModeBanner:false);
  }
}

class MyPagefulWidget extends StatefulWidget {
  MyPagefulWidget({Key key}) : super(key: key);
  @override
  _MyPagefulWidgetState createState() => _MyPagefulWidgetState();
}


class _MyPagefulWidgetState extends State<MyPagefulWidget> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    
    return Layer.buildContent('login', context, null, _click);
  }

  void _click(String type) {
    print('----');
    if(type == 'google') {
      _launchGoogle(context);
    } else if(type == 'facebook') {
      _launchFacebook(context);
    }
  }

  void _launchGoogle(BuildContext context) async {
    try{
        GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
        GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
        GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
        IfDialog().loading(context);
        bool logged = await Api.login({'type': 'google', 'idtoken': _googleAuth.idToken});
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(logged) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          _googleSignIn.disconnect();
        } else {
          IfDialog.show(context: context, text: 'บัญชีนี้ไม่สามารถล็อคอินได้');
        }
    } catch (err){
      IfDialog.show(context: context, text: 'ไม่สามารถล็อคอินได้ ('+err+')');
    }  
  }

  void _launchFacebook(BuildContext context) async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        IfDialog().loading(context);
        bool logged = await Api.login({'type': 'facebook', 'idtoken': result.accessToken.token});
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(logged) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          IfDialog.show(context: context, text: 'บัญชีนี้ไม่สามารถล็อคอินได้');
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        Site.log.i('cancel');
        //cancel
        break;
      case FacebookLoginStatus.error:      
        Site.log.i('error');
        break;
    }
  }
}
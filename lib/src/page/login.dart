import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:ifelse/src/convert/toast.dart';
import '../site.dart';
import '../layer.dart';
import '../page/home.dart';
import '../page/checkout.dart';
import '../convert/dialog.dart';
import '../convert/api.dart';

class LoginPage extends StatefulWidget {
  final String next;
  LoginPage({Key key, this.next}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LoginState(next);
  }
}

class LoginState extends State<LoginPage> {
  String next;
  LoginState(this.next);

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
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {
        return Layer.buildContent('login', context, null, _click);
      }
    );
  }

  void _click(String type) {
    if(type == 'google') {
      _launchGoogle(context);
    } else if(type == 'facebook') {
      _launchFacebook(context);
    }
  }

  void _launchGoogle(BuildContext context) async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      String token = _googleAuth.idToken;
      if((token != null) && (token.isNotEmpty)) {
        IfDialog().loading(context);
        bool logged = await Api.login({'type': 'google', 'idtoken': _googleAuth.idToken});
        Navigator.of(context, rootNavigator: true).pop('dialog');
        if(logged) {
          if(next == 'checkout') {
            Get.off(CheckoutPage());
          } else {
            Get.off(HomePage());
            //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
          }
          _googleSignIn.disconnect();
          return;
        }
      }
    } catch (err){
      print(err);
    }  
    Toast.show('การล็อคอินไม่สำเร็จ', context, duration: Toast.lengthLong, gravity:  Toast.bottom);
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
          if(next == 'checkout') {
            Get.off(CheckoutPage());
          } else {
            Get.off(HomePage());
          }
          return;
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('cancel');
        //cancel
        break;
      case FacebookLoginStatus.error:      
        print('error');
        break;
    }
    Toast.show('การล็อคอินไม่สำเร็จ', context, duration: Toast.lengthLong, gravity:  Toast.bottom);
  }
}
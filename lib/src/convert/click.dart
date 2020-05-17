import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import '../site.dart';
import '../page/articles.dart';
import '../page/products.dart';
import '../page/jobs.dart';
import '../convert/dialog.dart';

void getClicked(BuildContext context,dynamic click) {
  if(click != null && click is Map) {
    switch (click['type'].toString()) {
      case 'link':
        _launchLink(click['link'] ?? 'https://ifelse.co');
        break;
      case 'articles':
        _launchArticles(context, click);
        break;
      case 'products':
        _launchProducts(context, click);
        break;
      case 'jobs':
        _launchJobs(context, click);
        break;
      case 'google':
        _launchGoogle(context, click);
        break;
      case 'facebook':
        _launchFacebook(context, click);
        break;
      case 'article':
      case 'product':
      case 'job':
    }
  }
}

void _launchLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _launchArticles(BuildContext context, Map click) {
  Map<String, dynamic> request = {'category':click['articles']};
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlesPage(par:request)));
}

void _launchProducts(BuildContext context, Map click) {
  Map<String, dynamic> request = {'category':click['products']};
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductsPage(par:request)));
}

void _launchJobs(BuildContext context, Map click) {
  Map<String, dynamic> request = {'category':click['jobs']};
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobsPage(par:request)));
}

void _launchGoogle(BuildContext context, Map click) async {
  try{
      IfDialog().loading(context);
      GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount _googleUser = await _googleSignIn.signIn();
      GoogleSignInAuthentication _googleAuth = await _googleUser.authentication;
      String token =  _googleAuth.idToken;
      while (token.length > 0) {
        int initLength = (token.length >= 500 ? 500 : token.length);
        print(token.substring(0, initLength));
        int endLength = token.length;
        token = token.substring(initLength, endLength);
      }

     //if(_dialog != null) {
        IfDialog().hide();
      //}
  } catch (err){
    //IfDialog.show(context: context, text: 'ไม่สามารถล็อคอินได้ ('+err+')');
    Site.log.i(err);
  }  
}

void _launchFacebook(BuildContext context, Map click) async {
  final facebookLogin = FacebookLogin();
  final result = await facebookLogin.logIn(['email']);

  switch (result.status) {
    case FacebookLoginStatus.loggedIn:
      // logged
      Site.log.i(result.accessToken.userId);
      Site.log.i(result.accessToken.declinedPermissions);
      Site.log.i(result.accessToken.token);
      break;
    case FacebookLoginStatus.cancelledByUser:
      Site.log.i('cancel');
      Site.log.i(result.errorMessage);
      //cancel
      break;
    case FacebookLoginStatus.error:      
      Site.log.i('error');
      Site.log.i(result.errorMessage);
      //error
      break;
  }
}
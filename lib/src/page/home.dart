import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../bloc/cart.dart';
import 'order.dart';

class HomePage extends StatelessWidget {
  final String next;
  final Map par;
  HomePage({Key key, this.next, this.par}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: HomePageWidget(next: next, par: par), debugShowCheckedModeBanner:false);
  }
}

class HomePageWidget extends StatefulWidget {
  final String next;
  final Map par;
  HomePageWidget({Key key, this.next, this.par}) : super(key: key);
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState(next: next, par: par);
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final String next;
  final Map par;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  _HomePageWidgetState({Key key, this.next, this.par});

  TabController controller;
  Widget render;
  @override
  void initState() {
    render = null;
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        Map mapNotification = message["notification"];
        String title = mapNotification["title"];
        String body = mapNotification["body"];
        //sendNotification(title: title, body: body);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) {
      if(token != null) {
        Site.fcm = token;
      }
    });
  }

  @override
  void dispose() {
    render = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(Site.cartBloc == null) {
      Site.cartBloc = CartBloc();
      Cart.init();
    }
    if(render == null) {
      render = BlocProvider<CartBloc>(
        create: (context) => Site.cartBloc,
        child: Layer.buildContent('home',context)
      );
    }
    _openNext();
    return render;
  }

  _openNext() async {
    print(next);
    print(par);
    if((next != null) && (next is String)) {
      print('1');
      if((next == 'order') && (par != null)) {
        print('2');
        Timer(Duration(seconds: 1),() {
          print('3');
          Get.to(OrderPage(id:getInt(par['id'])));
        });
      }
    }
  }

}
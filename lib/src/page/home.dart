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

class HomePage extends StatefulWidget {
  final String next;
  final Map par;
  HomePage({Key key, this.next, this.par}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HoneState(next: next, par: par);
  }
}

class HoneState extends State<HomePage> {
  final String next;
  final Map par;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  HoneState({Key key, this.next, this.par});

  TabController controller;
  //Widget render;
  @override
  void initState() {
    //render = null;
    super.initState();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        //Map mapNotification = message["notification"];
        //String title = mapNotification["title"];
        //String body = mapNotification["body"];
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
    //render = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(Site.cartBloc == null) {
      Site.cartBloc = CartBloc();
      Cart.init();
    }

    _openNext();
/*
    if(render == null) {
      render = BlocProvider<CartBloc>(
        create: (context) => Site.cartBloc,
        child: Layer.buildContent('home',context)
      );
    }
    return render;
*/
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {   
        return BlocProvider<CartBloc>(
          create: (context) => Site.cartBloc,
          child: Layer.buildContent('home',context)
        );
      }
    );
  }

  _openNext() async {
    if((next != null) && (next is String)) {
      if((next == 'order') && (par != null)) {
        Timer(Duration(seconds: 1),() {
          Get.to(OrderPage(id:getInt(par['id'])));
        });
      }
    }
  }
}
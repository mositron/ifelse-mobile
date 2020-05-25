import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class CartPage extends StatelessWidget {
  CartPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: CartPageWidget(), debugShowCheckedModeBanner:false);
  }
}

class CartPageWidget extends StatefulWidget {
  CartPageWidget({Key key}) : super(key: key);
  @override
  _CartPageWidgetState createState() => _CartPageWidgetState();
}

class _CartPageWidgetState extends State<CartPageWidget> {

  @override
  Widget build(BuildContext context) {
    return Layer.buildContent('cart',context);
  }
}
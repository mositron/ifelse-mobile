import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class CartPage extends StatefulWidget {
  CartPage({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CartState();
  }
}

class CartState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Color(0xffe0e0e0),
      builder: (context, child) {
        return Layer.buildContent('cart',context);
      }
    );
  }
}
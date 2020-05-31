import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class ProductsPage extends StatefulWidget {
  ProductsPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  State<StatefulWidget> createState() {
    return ProductsState(par);
  }
}

class ProductsState extends State<ProductsPage> {
  bool loaded;
  Map<String, dynamic> par;
  ProductsState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> request = {
      'category': par['category'] ?? '0',
      'status': '',
      'tag': '',
      'order': '',
      'skip': '0'
    };
    if(request['category'] != '0') {
      if((Site.products is List) && (Site.products.length > 0)) {
        Site.products.forEach((v) {
          String _id = v['_id'].toString();
          if(_id == request['category']) {
            request['text'] = v['title'].toString();
          }
        });
      } else {
        request['text'] = '';
      }
    } else {
      request['text'] = 'สินค้าทั้งหมด';
    }

    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {
        return Layer.buildContent('products', context, request);
      }
    );
  }
}
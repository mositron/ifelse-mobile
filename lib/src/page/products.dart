import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../layer.dart';

class ProductsPage extends StatelessWidget {
  ProductsPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ProductsPageWidget(buildContext: context, par: par));
  }
}

class ProductsPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  final BuildContext buildContext;
  ProductsPageWidget({Key key, this.buildContext, this.par}) : super(key: key);
  @override
  _ProductsPageWidgetState createState() => _ProductsPageWidgetState(buildContext, par);
}

class _ProductsPageWidgetState extends State<ProductsPageWidget> {
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;

  _ProductsPageWidgetState(this.buildContext, this.par);
  
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
    return Layer.buildContent('products', buildContext, request);
  }
}
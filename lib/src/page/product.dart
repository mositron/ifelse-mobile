import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/product.dart';
import '../convert/loading.dart';
import '../convert/util.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ProductPageWidget(par: par));
  }
}

class ProductPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  ProductPageWidget({Key key, this.par}) : super(key: key);
  @override
  _ProductPageWidgetState createState() => _ProductPageWidgetState(par);
}

class _ProductPageWidgetState extends State<ProductPageWidget> with SingleTickerProviderStateMixin {
  bool loaded;
  TabController controller;
  Map<String, dynamic> par;

  _ProductPageWidgetState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    //Site.log.e('get product - ' + getVal(par, '_id').toString());
    int id = getInt(getVal(par, '_id'));
    if(id > 0) {
      return Container(
        color: Colors.transparent,
        child: FutureBuilder<Map>(
          future: Product.getProduct(id),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? getWidget(snapshot.data)
                    : Product.retryButton(fetch)
                : getLoading();
          }
        )
      );
    } else {
      //throw Exception("Invalid ID.\nPlease Retry");
      return Container();
    }
  }

  setLoading(bool loading) {
    setState(() {
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }

  Widget getWidget(dynamic data) {
    if(data is Map) {
      return Layer.buildContent('product',context, data);
    }
    return Container();
  }
}
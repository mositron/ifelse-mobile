import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/product.dart';
import '../convert/dialog.dart';
import '../convert/util.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ProductPageWidget(buildContext: context, par: par));
  }
}

class ProductPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  final BuildContext buildContext;
  ProductPageWidget({Key key, this.buildContext, this.par}) : super(key: key);
  @override
  _ProductPageWidgetState createState() => _ProductPageWidgetState(buildContext, par);
}

class _ProductPageWidgetState extends State<ProductPageWidget> {
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;

  _ProductPageWidgetState(this.buildContext, this.par);
  
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
        color: Color(0xfff0f0f0),
        child: FutureBuilder<Map>(
          future: Product.getProduct(id),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? getWidget(snapshot.data)
                    : Product.retryButton(fetch)
                : IfDialog.getLoading();
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
      return Layer.buildContent('product', buildContext, data);
    }
    return Container();
  }
}
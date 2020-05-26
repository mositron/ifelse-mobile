import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/product.dart';
import '../convert/dialog.dart';
import '../convert/util.dart';
import '../convert/cart.dart';
import '../convert/toast.dart';
import '../bloc/product.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: ProductPageWidget(buildContext: context, par: par), debugShowCheckedModeBanner:false);
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
  Widget render;
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;
  int id = 0,
    diff = 0,
    eachStyle = 0,
    eachStyle1 = -1,
    eachStyle2 = -1,
    eachCount = 0,
    eachCount1 = 0,
    eachCount2 = 0,
    amount = 1,
    index = 0;
  String title = '',
    eachName1 = '',
    eachName2 = '';
  Map image;
  List<double> price = [0, 0];
  List<Map> items = [];
  ProductBloc productBloc;


  _ProductPageWidgetState(this.buildContext, this.par);
  
  @override
  void initState() {
    loaded = false;
    super.initState();
  }
  
  @override
  void dispose() {
    loaded = false;
    productBloc.drain();
    productBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    productBloc = ProductBloc();
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
      id = getInt(data['_id']);
      title = getString(data['title']);
      image = data['image'];
      diff = getInt(data['diff']);
      

      if(diff > 0) {
        items = [];
        List<Map> _items = getVal(data,'each.item');
        if((_items != null) && (_items is List)) {
          _items.forEach((v) { 
            items.add(
              {
                'sku': getString(v['sku']),
                'stock': getInt(v['stock']),
                'price': getDouble(v['price']),
              }
            );
          });
        }
      }


      //double productPrice = 0; 
      if(data['price'] is List) {
        List<dynamic> _price = data['price'];
        if(_price.length == 2) {
          price = [getDouble(price[0]), getDouble(price[1])];
        }
      }
      /*
      if(diff > 0) {
        if(_price[0] > 0 && _price[1] > 0) {
          
        } else if(_price[1] > 0) {
          
        }
      } else {
        if(_price[0] > 0 && _price[1] > 0) {
          
        } else if(_price[1] > 0) {
          
        }
      }
      */
      
      return BlocProvider<ProductBloc>(
        create: (context) => productBloc,
        child: Layer.buildContent('product', context, data, _click)
      );
    }
    return Container();
  }


  void _click(String type, [Map data]) {
    if(type == 'button') {
      Map item = {
        'id': id,
        'title': title,
        'image': image,
        'amount': amount,
        'diff': 0
      };
      if(diff == 0) {
        Cart.add(item);
        amount = 1;
        productBloc.add({'type':'clear'});
      } else {
        if(eachStyle1 == -1) {
          Toast.show('กรุณาเลือก '+eachName1, context, duration: Toast.lengthShort, gravity:  Toast.bottom);
        } else if((eachStyle == 2) && (eachStyle2 == -1)) {
          Toast.show('กรุณาเลือก '+eachName2, context, duration: Toast.lengthShort, gravity:  Toast.bottom);
        } else {
          item['diff'] = eachStyle;
          item['style1'] = eachStyle1;
          if(eachStyle == 2) {
            item['style2'] = eachStyle2;
          }
          Cart.add(item);          
          eachStyle1 = -1;
          eachStyle2 = -1;
          amount = 1;
          productBloc.add({'type':'clear'});
        }
      }
    } else if(type == 'spec') {
      if(data['type'] == 'inc') {
        amount++;
        productBloc.add({'type':'amount','value':amount});
      } else if(data['type'] == 'dec') {
        amount--;
        if(amount < 1) {
          amount = 1;
        }
        productBloc.add({'type':'amount','value':amount});
      } else if(data['type'] == 'style1') {
        eachStyle1 = data['index'];
        productBloc.add({'type':'style1','value':eachStyle1});
      } else if(data['type'] == 'style2') {
        eachStyle2 = data['index'];
        productBloc.add({'type':'style2','value':eachStyle2});
      }
    }
    //print(type);
  }
}
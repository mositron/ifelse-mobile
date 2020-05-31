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

class ProductPage extends StatefulWidget {
  ProductPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  State<StatefulWidget> createState() {
    return ProductState(par);
  }
}

class ProductState extends State<ProductPage> {
  Widget render;
  bool loaded;
  Map<String, dynamic> par;
  int id = 0,
    diff = 0,
    eachStyle = 0,
    eachStyle1 = -1,
    eachStyle2 = -1,
    eachCount = 1,
    eachCount1 = 1,
    eachCount2 = 1,
    amount = 1,
    index = 0,
    stock = 0,
    download = 0;
  String title = '',
    eachName1 = '',
    eachName2 = '',
    unit = '';
  Map image;
  double weight = 0;
  List<double> price = [0, 0];
  List<dynamic> items = [],
    style1 = [],
    style2 = [];
  ProductBloc productBloc;
  ProductState(this.par);
  
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
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {
        int id = getInt(getVal(par, '_id'));
        if(id > 0) {
          return FutureBuilder<Map<dynamic,dynamic>>(
            future: Product.getProduct(id),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                  ? getWidget(snapshot.data)
                  : Product.retryButton(fetch)
                : IfDialog.getLoading();
            }
          );
        } else {
          return Container();
        }    
      },  
    );  
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
      stock = getInt(data['stock']);
      download = getInt(data['download']);
      diff = getInt(data['diff']);
      Map dim = getVal(data,'dim');
      unit = getString(dim['unit']);
      weight = getDouble(dim['weight']);
      if(diff > 0) {
        items = [];
        dynamic _each = getVal(data,'each');
        eachStyle = getInt(_each['style']);
        eachCount1 = 1;
        eachCount2 = 1;
        if(eachStyle > 0) {
          Map _style1 = getVal(_each,'style1');
          eachName1 = getString(_style1['name']);
          style1 = _style1['item'];
          if((style1 != null) && (style1 is List) && (style1.length > 0)) {
            eachCount1 = style1.length;
          }
        }
        if(eachStyle > 1) {
          Map _style2 = getVal(_each,'style2');
          eachName2 = getString(_style2['name']);
          style2 = _style2['item'];
          if((style2 != null) && (style2 is List) && (style2.length > 0)) {
            eachCount2 = style2.length;
          }
        }

        dynamic _items = getVal(_each,'item');
        if((_items != null) && (_items is List)) {
          int i = 0;
          _items.forEach((v) { 
            int _s1 = (i / eachCount2).floor();
            int _s2 = (i % eachCount2);
            items.add(
              {
                'diff': 1,
                'index': i,
                'style1': _s1,
                'style2': _s2,
                'name1': eachName1,
                'name2': eachStyle > 1 ? eachName2 : '',
                'label1': getString(style1[_s1] != null ? style1[_s1]['name'] : ''),
                'label2': eachStyle > 1 ? getString(style2[_s2] != null ? style2[_s2]['name'] : '') : '',
                'sku': getString(v['sku']),
                'stock': getInt(v['stock']),
                'price': getDouble(v['price']),
              }
            );
            i++;
          });
        }
      }

      //double productPrice = 0; 
      if(data['price'] is List) {
        List<dynamic> _price = data['price'];
        if(_price.length == 2) {
          price = [getDouble(_price[0]), getDouble(_price[1])];
        }
      }
      
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
        'stock': stock,
        'unit': unit,
        'weight': weight,
        'download': download,
        'diff': 0,
        'price': 0.0,
        'index': 0,
        'style1': 0,
        'style2': 0,
        'name1': '',
        'name2': '',
        'label1': '',
        'label2': '',
      };
      if(diff == 0) {
        print(price);
        if(price[0] > 0 && price[1] > 0) {
          item['price'] = price[0];
        } else if(price[1] > 0) {
          item['price'] = price[1];
        }
        Cart.add(item);
        //amount = 1;
        productBloc.add({'type':'clear'});
      } else {
        if(eachStyle1 == -1) {
          Toast.show('กรุณาเลือก '+eachName1, context, duration: Toast.lengthLong, gravity:  Toast.bottom);
        } else if((eachStyle == 2) && (eachStyle2 == -1)) {
          Toast.show('กรุณาเลือก '+eachName2, context, duration: Toast.lengthLong, gravity:  Toast.bottom);
        } else {
          bool found = false;
          if(items.length > 0) {
            items.forEach((v) { 
              if((v['style1'] == eachStyle1) && ((eachStyle == 1) || (v['style2'] == eachStyle2))) {
                item.addAll(v);
                found = true;
              }
            });
          }
          if(found) {
            Cart.add(item);
          } else {
            Toast.show('ไม่มีสินค้าที่เลือก', context, duration: Toast.lengthLong, gravity:  Toast.bottom);
          }
        }
      }
    } else if(type == 'spec') {
      if(data['type'] == 'inc') {
        amount++;
        if(download == 1) {
          amount = 1;
        } else if(diff == 0) {
          print(1);
          if(amount > stock) {
            amount = stock;
            Toast.show('มีจำนวนสินค้าชนิดนี้นคลัง '+amount.toString()+' '+unit, context, duration: Toast.lengthLong, gravity:  Toast.bottom);
          }
        } else {
          if((eachStyle == 1) && (eachStyle1 > -1)) {
            if(amount > items[eachStyle1]['stock']) {
              amount = items[eachStyle1]['stock'];
            }
          } else if((eachStyle == 2) && (eachStyle1 > -1) && (eachStyle2 > -1)) {
            index = (eachStyle1 * eachCount2) + eachStyle2;
            if(amount > items[index]['stock']) {
              amount = items[index]['stock'];
            }
          }
        }
        productBloc.add({'type':'amount','value':amount});
      } else if(data['type'] == 'dec') {
        amount--;
        if(download == 1) {
          amount = 1;
        } else if(amount < 1) {
          amount = 1;
        }
        productBloc.add({'type':'amount','value':amount});
      } else if(data['type'] == 'style1') {
        eachStyle1 = data['index'];
        if(eachStyle == 1) {
          productBloc.add({'type':'update','value':{'style1':eachStyle1,'price':items[eachStyle1]['price'],'stock':items[eachStyle1]['stock'],'unit':unit}});
        } else if(eachStyle2 > -1) {
          index = (eachStyle1 * eachCount2) + eachStyle2;
          productBloc.add({'type':'update','value':{'style1':eachStyle1,'style2':eachStyle2,'price':items[index]['price'],'stock':items[index]['stock'],'unit':unit}});
        } else {
          productBloc.add({'type':'style1','value':eachStyle1});
        }
      } else if(data['type'] == 'style2') {
        eachStyle2 = data['index'];
        if(eachStyle1 > -1) {
          index = (eachStyle1 * eachCount2) + eachStyle2;
          productBloc.add({'type':'update','value':{'style1':eachStyle1,'style2':eachStyle2,'price':items[index]['price'],'stock':items[index]['stock'],'unit':unit}});
        } else {
          productBloc.add({'type':'style2','value':eachStyle2});
        }
      }
    }
  }
}
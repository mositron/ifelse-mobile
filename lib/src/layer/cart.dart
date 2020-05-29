import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../layer.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/border.dart';
import '../convert/gradient.dart';
import '../convert/edge.dart';
import '../convert/shadow.dart';
class CartParser extends WidgetParser {
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    return new CartView(key: UniqueKey(), file: file, map: map, buildContext: buildContext, par: par);    
  }
  
  @override
  String get widgetName => 'cart';
}

class CartView extends StatefulWidget {
  final dynamic map;
  final BuildContext buildContext;
  final String file;
  final dynamic par;
  final Function func;
  CartView({Key key, this.file, this.map, this.buildContext, this.par, this.func}) : super(key: key);

  @override
  _CartViewState createState() {
    //print(_map);
    return new _CartViewState(file, map, buildContext, par, func);
  }
}
 
class _CartViewState extends State<CartView> {
  bool loaded;
  dynamic _map;
  String _file;
  BuildContext buildContext;
  dynamic _par;
  Function _func;
  _CartViewState(this._file, this._map, this.buildContext, this._par, this._func);

  @override
  Widget build(BuildContext context) {
    dynamic box = getVal(_map,'box'),
    price = getVal(_map,'data.price');
    Color _color = getColor(getVal(price, 'color'), '000');
    double _fsize = getDouble(getVal(price, 'size'), 16);
    
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment.topCenter,
      //alignment: Alignment(0.0, 0.0),
      child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(0),
        itemCount: Cart.products.length,
        itemBuilder: (context, index) {
          final v = Cart.products[index];
          return Dismissible(
            key: UniqueKey(),
            onDismissed: (direction) {
              setState(() {
                Cart.products.removeAt(index);
                Cart.refresh();
              });
            },
            confirmDismiss: (DismissDirection direction) async {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('ยืนยันการลบรายการสินค้า'),
                    content: const Text('ต้องการลบรายการสินค้านี้หรือไม่?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('ลบ')
                      ),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('ยกเลิก'),
                      ),
                    ],
                  );
                },
              );
            },
            child: CartCell(
              id: v['id'],
              index: v['index'],
              title: v['title'],
              image: v['image'],
              amount: getInt(v['amount']),
              price: getDouble(v['price']),
              name1: v['name1'],
              label1: v['label1'],
              name2: v['name2'],
              label2: v['label2'],
              stock: getInt(v['stock']),
              color: _color,
              fsize: _fsize,
            )
          );
        }
      )
    );
  }
}

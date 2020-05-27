import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layer.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/border.dart';
import '../convert/icon.dart';
import '../convert/gradient.dart';
import '../convert/image.dart';
import '../convert/edge.dart';
import '../convert/shadow.dart';
import '../bloc/cart.dart';
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
    //Site.log.w(_map);
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
      alignment: Alignment(0.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(),
          Container(
            decoration: BoxDecoration(
              color: getColor('f0f0f0')
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: Cart.getList(_color, _fsize),
            )
          )
        ]
      )
    );
  }
}

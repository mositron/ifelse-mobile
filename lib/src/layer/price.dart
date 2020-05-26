
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layer.dart';
import '../site.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../bloc/product.dart';

class PriceParser extends WidgetParser {
  @override
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    dynamic box = getVal(map,'box');
    dynamic data = getVal(map,'data');
    dynamic normal = getVal(data,'price.normal');
    Color normalColor  = getColor(getVal(normal,'color'),'000');
    double normalSize  = getDouble(getVal(normal,'size'),Site.fontSize);    
    dynamic over = getVal(data,'price.over');
    Color overColor  = getColor(getVal(over,'color'),'000');
    double overSize  = getDouble(getVal(over,'size'),14);
    Widget _widget;
    
    List<double> _price = [0, 0]; 
    if(par['price'] is List) {
      List<dynamic> price = par['price'];
      if(price.length == 2) {
        _price = [getDouble(price[0]), getDouble(price[1])];
      }
    }
    int diff = getInt(getVal(par,'diff'));
    if(diff > 0) {
      if(_price[0] > 0 && _price[1] > 0) {
        int eachStyle = getInt(getVal(par,'each.style'));
        _widget = Container(
          child: BlocBuilder<ProductBloc, Map>(
            bloc: buildContext.repository<ProductBloc>(),
            builder: (_, product) {
              if((product['price'] > 0) && (((eachStyle == 1) && (product['style1'] > -1)) || ((eachStyle == 2) && (product['style1'] > -1) && (product['style2'] > -1)))) {
                return Text.rich(
                  TextSpan(
                    text: '฿' + getCurrency(product['price']),
                    style: TextStyle(color: normalColor,fontSize: normalSize),
                  )
                );
              }
              return Text.rich(
                TextSpan(
                  text: '฿' + getCurrency(_price[0]),
                  style: TextStyle(color: normalColor,fontSize: normalSize),
                  children: <InlineSpan>[
                    TextSpan(
                      text: ' ~ ',  
                      style: TextStyle(color: normalColor,fontSize: normalSize),
                    ),
                    TextSpan(
                      text: '฿' + getCurrency(_price[1]),             
                      style: TextStyle(color: normalColor,fontSize: normalSize),
                    ),
                  ],
                )
              );
            }
          )
        );
      } else if(_price[1] > 0) {
        _widget = Container(
          child: Text.rich(
            TextSpan(
              text: '฿' + getCurrency(_price[1]),
              style: TextStyle(color: normalColor,fontSize: normalSize),
            ),
          )
        );
      }
    } else {
      if(_price[0] > 0 && _price[1] > 0) {
        _widget = Container(
          child: Text.rich(
            TextSpan(
              text: '฿' + getCurrency(_price[0]),
              style: TextStyle(color: normalColor,fontSize: normalSize),
              children: <InlineSpan>[
                TextSpan(
                  text: ' ',  
                  style: TextStyle(color: Color(0xffffffff),fontSize: normalSize),
                ),
                TextSpan(
                  text: '฿' + getCurrency(_price[1]),             
                  style: TextStyle(color: overColor,fontSize: overSize, decoration: TextDecoration.lineThrough),
                ),
              ],
            )
          )
        );
      } else if(_price[1] > 0) {
        _widget = Container(
          child: Text.rich(
            TextSpan(
              text: '฿'+getCurrency(_price[1]),
              style: TextStyle(color: Color(0xffffffff),fontSize: Site.fontSize),
            )
          )
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: _widget
    );
  }
  @override
  String get widgetName => 'price';
}

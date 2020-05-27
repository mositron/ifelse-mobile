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
    
    return Stack(
      children: [
        Container(
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
        ),

        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ยอดรวมสินค้า', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)),
                    BlocBuilder<CartBloc, int>(
                      bloc: Site.cartBloc,
                      builder: (_, count) {
                        return Text(getCurrency(Cart.getPrice()), style: TextStyle(fontFamily: Site.font, color: _color, fontSize: _fsize));
                      }
                    )
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: _getButton('cart'),
              )
            ],
          ),
        )
      ]
    );
  }

  Widget _getButton(String type) {
    dynamic _cart = getVal(_map,'data.'+type);
    String cartText = getVal(_cart,'text').toString();
    Color cartColor = getColor(getVal(_cart,'color'));
    double cartFSize = getDouble(getVal(_cart,'size') ?? Site.fontSize);
    IconData cartIcon = getIcon(getVal(_cart,'icon'));
    String cartIpos = getVal(_cart,'ipos').toString();
    Gradient cartBgcolor = getGradient(getVal(_cart,'bg.color'));
    DecorationImage cartBg = getImageBG(getVal(_cart,'bg'));
    Border cartBorder = getBorder(getVal(_cart,'border'));
    BorderRadius cartRadius = getBorderRadius(getVal(_cart,'border'));
    List<BoxShadow> cartShadow = getBoxShadow(getVal(_cart,'shadow'));
    EdgeInsetsGeometry cartSpace = getEdgeInset(getVal(_cart,'space'));

    List<Widget> widget = [];
    Icon _icon = Icon(cartIcon, color: cartColor, size: cartFSize,);
    Text _text = Text(cartText, style: TextStyle(color:cartColor,fontFamily: Site.font, fontSize: cartFSize));
    
    if(cartText.isNotEmpty && cartIcon != null) {
      if(cartIpos == 'right') {
        widget = [_text, SizedBox(width: 8), _icon,];
      } else if(cartIpos == 'up') {
        widget = [_icon, SizedBox(height: 3), _text,];
      } else {
        widget = [_icon, SizedBox(width: 8), _text,];
      }
    } else if(cartText.isNotEmpty) {
      widget = [_text];
    } else if(cartIcon != null) {
      widget = [_icon];
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        //alignment: getAlignBox(align),
        decoration: BoxDecoration(
          borderRadius: cartRadius,
          boxShadow: cartShadow,
        ),
        child: RawMaterialButton(
          onPressed: () {
            
          },
          padding: EdgeInsets.all(0.0),
          elevation: 0.0,     
          child: Ink(            
            decoration: BoxDecoration(
              gradient: cartBgcolor,
              borderRadius: cartRadius,
              border: cartBorder,
              image: cartBg,
            ),
            padding: cartSpace,
            child: cartIpos == 'up' ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                mainAxisSize: MainAxisSize.min,
                children: widget,
              )
              :
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                mainAxisSize: MainAxisSize.min,
                children: widget,
            )
          )
        )
      )
    );
  }
}

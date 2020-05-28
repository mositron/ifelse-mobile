import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../my.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/border.dart';
import '../convert/icon.dart';
import '../convert/gradient.dart';
import '../convert/image.dart';
import '../convert/edge.dart';
import '../convert/shadow.dart';
import '../convert/toast.dart';
import '../bloc/cart.dart';
import '../page/login.dart';
import '../page/checkout.dart';

class CartBar extends StatefulWidget {
  final dynamic map;
  final Function func;
  CartBar(this.map, this.func);
  @override
  _CartBar createState() => _CartBar(map, func);
}

class _CartBar extends State<CartBar> {
  dynamic map;
  Function func;
  _CartBar(this.map, this.func);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic box = getVal(map,'box'),
    price = getVal(map,'data.price');
    Color _color = getColor(getVal(price, 'color'), '000');
    double _fsize = getDouble(getVal(price, 'size'), 16);    
    return Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: getGradient(getVal(box,'bg.color')),
          borderRadius: getBorderRadius(getVal(box,'border')),
          boxShadow: getBoxShadow(getVal(box,'shadow')),
        ),
        margin: getEdgeInset(getVal(box,'margin')),
        padding: getEdgeInset(getVal(box,'padding')),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ยอดรวมสินค้า', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)),
                BlocBuilder<CartBloc, int>(
                  bloc: Site.cartBloc,
                  builder: (_, count) {
                    return Text(getCurrency(Cart.price), style: TextStyle(fontFamily: Site.font, color: _color, fontSize: _fsize));
                  }
                )
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              child: _getButton('btn'),
            )
          ],
        )
    );
  }
  

  Widget _getButton(String type) {
    dynamic _cart = getVal(map,'data.'+type);
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
            if(Cart.products.length > 0) {
              if(My.id > 0) {
                Get.to(CheckoutPage());
              } else {
                Get.to(LoginPage(next: 'checkout'));
              }
            } else {
              Toast.show('ยังไม่มีรายการสินค้าในตะกร้า', context, duration: Toast.lengthShort, gravity:  Toast.bottom);
            }
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

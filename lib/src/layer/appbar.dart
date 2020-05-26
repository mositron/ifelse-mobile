import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../site.dart';
import '../convert/icon.dart';
import '../convert/image.dart';
import '../convert/gradient.dart';
import '../convert/util.dart';
import '../page/cart.dart';
import '../bloc/cart.dart';
import '../convert/cart.dart';

AppBar getAppBar(dynamic obj, BuildContext buildContext,  Function appClick) {
  if ((obj != null) && !(obj is List)) {
    dynamic box = getVal(obj,'box'),
      data = getVal(obj,'data'),
      logo = getVal(data,'logo'),
      nav = getVal(data,'nav'),
      cart = getVal(data,'cart');
    String logoStyle = getVal(logo,'style'),
      navStyle = getVal(nav,'style'),
      cartStyle = getVal(cart,'style');
    Widget _title, _leading,_action;
    if(logoStyle == 'text') {
      _title = Text(
        getVal(logo, 'text') ?? '',
        style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(logo,'size'), Site.fontSize),color: getColor(getVal(logo,'color'),'fff'))
      );
    } else if(logoStyle == 'image') {
      _title = Image.network(getImage(getVal(data,'image'),'s'));
    }
    if(navStyle == 'action') {
      _leading = IconButton(
        icon: Icon(
          getIcon(getVal(nav,'icon')),
          color: getColor(getVal(nav,'color'),'000'),
          size: getDouble(getVal(nav,'size'),Site.fontSize),
        ),      
        onPressed: () {
          appClick();
        }
      );
    }
    if(cartStyle == 'action') {
      _action = GestureDetector(
        onTap:() {
          Get.to(CartPage());
        },
        child: Stack(
          alignment: Alignment.topRight,
          overflow: Overflow.visible,
          children: [
            IconButton(
              icon: Icon(
                getIcon(getVal(cart,'icon')),
                color: getColor(getVal(cart,'color'),'000'),
                size: getDouble(getVal(cart,'size'),Site.fontSize),
              ),      
              onPressed: () {}
            ),
            Positioned(
              top: 5,
              left: 5,
              child: 
                BlocBuilder<CartBloc, int>(
                  bloc: Site.cartBloc,
                  builder: (_, count) {
                    return Cart.amount == 0 ? Container(
                        width: 1,
                        height: 1,
                      ) : Container(
                    padding: EdgeInsets.only(left:5,right:5,top:0,bottom:0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text(Cart.amount.toString(), style: TextStyle(color: Colors.white, fontFamily: Site.font, fontSize: 14)),
                  );
                }
              )
            ),
          ],
        )
      );
    }
  
    
    return AppBar(
      title: _title,
      centerTitle: getVal(logo,'align') == 'center',
      leading: _leading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: getGradient(getVal(box,'bg.color')),
          image: getImageBG(getVal(box,'bg')),          
        )
      ),
      actions: _action != null ?
        <Widget>[_action] :
        null
    );
  }
  return null;
}
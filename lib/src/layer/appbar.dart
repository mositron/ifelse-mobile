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
import 'tabbar.dart';

AppBar getAppBar(BuildContext buildContext, int showNavBar, dynamic appObj, Function appClick, TabController _tabController) {
  if ((appObj != null) && !(appObj is List)) {
    dynamic box = getVal(appObj,'box'),
      data = getVal(appObj,'data'),
      logo = getVal(data,'logo'),
      nav = getVal(data,'nav'),
      cart = getVal(data,'cart');
    String logoStyle = getVal(logo,'style'),
      navStyle = getVal(nav,'style'),
      cartStyle = getVal(cart,'style');
    int light = getInt(getVal(data,'light'));
    Widget _title, _leading,_action;
    if(logoStyle == 'text') {
      _title = Text(
        getVal(logo, 'text') ?? '',
        style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(logo,'size'), Site.fontSize),color: getColor(getVal(logo,'color'),'fff'))
      );
    } else if(logoStyle == 'image') {
      _title = getImageRatio(getVal(data,'image'),'s',0);

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
      _action = Stack(
        alignment: Alignment.topRight,
        overflow: Overflow.visible,
        children: [
          IconButton(
            icon: Icon(
              getIcon(getVal(cart,'icon')),
              color: getColor(getVal(cart,'color'),'000'),
              size: getDouble(getVal(cart,'size'),Site.fontSize),
            ),      
            onPressed: () {
              Get.to(CartPage());
            }
          ),
          Positioned(
            top: 5,
            left: 5,
            child: GestureDetector(
              onTap:() {
                Get.to(CartPage());
              },
              child: BlocBuilder<CartBloc, int>(
                bloc: Site.cartBloc,
                builder: (_, count) {
                  return Cart.amount == 0 ? Container(
                      width: 1,
                      height: 1,
                    ) : Container(
                    padding: EdgeInsets.all(0),
                    margin: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    constraints:  BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    alignment: Alignment.center,
                    child: Text(Cart.amount.toString(), style: TextStyle(color: Colors.white, fontFamily: Site.font, fontSize: 14)),
                  );
                }
              )
            ),
          )
        ]
      );
    }
  
    Widget _bottom;
    if(showNavBar == 3) {
      _bottom = getTabBar(buildContext, _tabController, appObj, appClick);
    }

    return AppBar(
      title: _title,
      centerTitle: getVal(logo,'align') == 'center',
      leading: _leading,
      backgroundColor: Colors.transparent,
      brightness: light == 1 ? Brightness.light : Brightness.dark,
      elevation: 0,
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {  
          print('$viewportConstraints'); 
          return Container(
            child: CustomPaint(
              size: Size(viewportConstraints.maxWidth, viewportConstraints.maxHeight),
              painter: DrawCurve(getVal(box,'bg.color')),
            ),
            decoration: BoxDecoration(
              gradient: getGradient(getVal(box,'bg.color')),
              image: getImageBG(getVal(box,'bg')),          
            ),
          );
        }
      ),
      actions: _action != null ?
        <Widget>[_action] :
        null,
      bottom: _bottom,
    );
  }
  return null;
}
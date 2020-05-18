import 'package:flutter/material.dart';
import '../convert/icon.dart';
import '../convert/image.dart';
import '../convert/gradient.dart';
import '../convert/util.dart';

AppBar getAppBar(dynamic obj, BuildContext buildContext,  Function appClick) {
  if ((obj != null) && !(obj is List)) {
    dynamic box = getVal(obj,'box'),
      data = getVal(obj,'data'),
      logo = getVal(data,'logo'),
      nav = getVal(data,'nav');
    String logoStyle = getVal(logo,'style'),
      navStyle = getVal(nav,'style');
    Widget _title, _leading;
    if(logoStyle == 'text') {
      _title = Text(
        getVal(logo, 'text') ?? '',
        style: TextStyle(fontFamily: 'Kanit',fontSize: getDouble(getVal(logo,'size'), 16),color: getColor(getVal(logo,'color'),'fff'))
      );
    } else if(logoStyle == 'image') {
      _title = Image.network(getImage(getVal(data,'image'),'s'));
    }
    if(navStyle == 'action') {
      _leading = IconButton(
        icon: Icon(
          getIcon(getVal(nav,'icon')),
          color: getColor(getVal(nav,'color'),'000'),
          size: getDouble(getVal(nav,'size'),16),
        ),      
        onPressed: () {
          appClick();
        }
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
    );
  }
  return null;
}
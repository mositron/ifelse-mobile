import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/icon.dart';
import '../site.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';

Widget getNavBar(dynamic obj, BuildContext buildContext) {
  
  if ((obj != null) && !(obj is List)) {
    dynamic box = getVal(obj,'box'),
      data = getVal(obj,'data'),
      hover = getVal(obj,'hover'),
      items = getVal(data,'items');
    List<BottomNavigationBarItem> _item = [];
    Color dataTextColor = getColor(getVal(data,'text.color'),'000');
    double dataTextSize = getDouble(getVal(data,'text.size'),16);
    Color dataIconColor = getColor(getVal(data,'icon.color'),'000');
    double dataIconSize = getDouble(getVal(data,'icon.size'),16);
    Color hoverTextColor = getColor(getVal(hover,'text.color'),'000');
    double hoverTextSize = getDouble(getVal(hover,'text.size'),16);
    Color hoverIconColor = getColor(getVal(hover,'icon.color'),'000');
    double hoverIconSize = getDouble(getVal(hover,'icon.size'),16);

    if((items != null) && (items is List)) {
      for(int i=0; i<items.length; i++) {
        Map v = items[i];
        Icon _icon = Icon(getIcon(v['icon']), size: i==0?hoverIconSize:dataIconSize, color: i==0?hoverIconColor:dataIconColor,);
        Text _title = Text(v['text'], style: TextStyle(fontSize: i==0?hoverTextSize:dataTextSize, color: i==0?hoverTextColor:dataTextColor, fontFamily: 'Kanit'));
        _item.add(BottomNavigationBarItem(icon: _icon, title: _title));
      };
    }
    if(_item.length >= 2) {

      return Container(
        decoration: BoxDecoration(
          gradient: getGradient(getVal(box,'bg.color')),
          borderRadius: getBorderRadius(getVal(box,'border')),
          boxShadow: getBoxShadow(getVal(box,'shadow')),
        ),
        margin: getEdgeInset(getVal(box,'margin')),
        padding: getEdgeInset(getVal(box,'padding')),
        child:BottomNavigationBar(
          items: _item,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          //selectedItemColor: hoverIconColor,
          //selectedFontSize: hoverTextSize,
          selectedLabelStyle: TextStyle(fontSize: hoverTextSize, color: hoverIconColor, fontFamily: 'Kanit'),
          selectedIconTheme: IconThemeData(size: hoverIconSize, color: hoverIconColor),
          
          //unselectedItemColor: dataTextColor,
          //unselectedFontSize: dataTextSize,
          unselectedLabelStyle: TextStyle(fontSize: dataTextSize, color: dataTextColor, fontFamily: 'Kanit'),
          unselectedIconTheme: IconThemeData(size: dataIconSize, color: dataIconColor),
          
          elevation: 0,
          currentIndex: 0,
          onTap: (index) {
            
          },
        )
      );
    }
  }
  return null;
}

import 'package:flutter/material.dart';
import '../site.dart';
import '../convert/icon.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';

class NavBar extends StatefulWidget {
  final dynamic map;
  final Function func;
  NavBar(this.map, this.func);
  @override
  _NavBar createState() => _NavBar(map, func);
}

class _NavBar extends State<NavBar> {
  dynamic map;
  Function func;
  int selectedIndex;

  _NavBar(this.map, this.func);

  @override
  void initState() {
    super.initState();
    selectedIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    if ((map != null) && (map is Map)) {
      dynamic box = getVal(map,'box'),
        data = getVal(map,'data'),
        hover = getVal(map,'hover'),
        items = getVal(data,'items');
      List<BottomNavigationBarItem> _item = [];
      Color dataTextColor = getColor(getVal(data,'text.color'),'000');
      double dataTextSize = getDouble(getVal(data,'text.size'),Site.fontSize);
      Color dataIconColor = getColor(getVal(data,'icon.color'),'000');
      double dataIconSize = getDouble(getVal(data,'icon.size'),Site.fontSize);
      Color hoverTextColor = getColor(getVal(hover,'text.color'),'000');
      double hoverTextSize = getDouble(getVal(hover,'text.size'),Site.fontSize);
      Color hoverIconColor = getColor(getVal(hover,'icon.color'),'000');
      double hoverIconSize = getDouble(getVal(hover,'icon.size'),Site.fontSize);
      if((items != null) && (items is List)) {
        for(int i=0; i<items.length; i++) {
          Map v = items[i];
          Icon _icon = Icon(getIcon(v['icon']));
          Text _title = Text(v['text']);
          _item.add(BottomNavigationBarItem(icon: _icon, title: _title));
        }
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
            selectedItemColor: hoverIconColor,
            selectedFontSize: hoverTextSize,
            selectedLabelStyle: TextStyle(fontSize: hoverTextSize, color: hoverTextColor, fontFamily: Site.font),
            selectedIconTheme: IconThemeData(size: hoverIconSize, color: hoverIconColor),
            unselectedItemColor: dataTextColor,
            unselectedFontSize: dataTextSize,
            unselectedLabelStyle: TextStyle(fontSize: dataTextSize, color: dataTextColor, fontFamily: Site.font),
            unselectedIconTheme: IconThemeData(size: dataIconSize, color: dataIconColor),
            elevation: 0,
            currentIndex: selectedIndex,
            onTap: (index) {
              setState(() {
                selectedIndex = index;
                func(index);
              });
            },
          )
        );
      }
    }
    return Container();
  }
}


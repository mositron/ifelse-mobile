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
  NavBar({Key key, this.map, this.func}) : super(key: key);
  @override
  NavBarState createState() {
    return NavBarState(map, func);
  }
}

class NavBarState extends State<NavBar> {
  dynamic map;
  Function func;
  int selectedIndex;
  NavBarState(this.map, this.func);

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
      String spec = getVal(map,'spec') ?? 'all';
      String iconColor = getVal(data,'icon.color') ?? '';
      String ipos = getVal(data,'icon.ipos') ?? '';
      Color dataTextColor = getColor(getVal(data,'text.color'),'000');
      double dataTextSize = getDouble(getVal(data,'text.size'),Site.fontSize);
      Color dataIconColor = iconColor.isNotEmpty ? getColor(iconColor,'000') : null;
      double dataIconSize = getDouble(getVal(data,'icon.size'),Site.fontSize);
      Color hoverTextColor = getColor(getVal(hover,'text.color'),'000');
      double hoverTextSize = getDouble(getVal(hover,'text.size'),Site.fontSize);
      //Color hoverIconColor = getColor(getVal(hover,'icon.color'),'000');
      //double hoverIconSize = getDouble(getVal(hover,'icon.size'),Site.fontSize);
      if((items != null) && (items is List)) {
        for(int i=0; i<items.length; i++) {
          /*
          Map v = items[i];
          Icon _icon = Icon(getIcon(v['icon']));
          Text _title = Text(v['text']);
          _item.add(BottomNavigationBarItem(icon: _icon, title: _title));
*/
          
          Map v = items[i];
          List<Widget> _child = [];
          Icon _icon = spec != 'text' ? Icon(getIcon(v['icon']), size: dataIconSize, color: dataIconColor) : null;
          Widget _text = spec != 'icon' ? Text(v['text']) : null;
          if((_icon != null) && (_text != null)) {
            if(ipos == 'right') {
              _child = [_text, SizedBox(width: 8), _icon,];
            } else if(ipos == 'left') {
              _child = [_icon, SizedBox(width: 8), _text,];
            } else {
              _child = [_icon, SizedBox(height: 3), _text,];
            }
          } else if(_text != null) {
            _child.add(_text);
          } else if(_icon != null) {
            _child.add(_icon);
          }
          
          _item.add(BottomNavigationBarItem(icon: Icon(null), title: ipos == 'up' ?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: _child,
                  )
                  :
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center ,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: _child,
                  )));
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
            selectedItemColor: hoverTextColor,
            selectedFontSize: hoverTextSize,
            selectedLabelStyle: TextStyle(fontSize: hoverTextSize, color: hoverTextColor, fontFamily: Site.font),
            selectedIconTheme: IconThemeData(size: dataIconSize, color: dataIconColor ?? hoverTextColor),
            unselectedItemColor: dataTextColor,
            unselectedFontSize: dataTextSize,
            unselectedLabelStyle: TextStyle(fontSize: dataTextSize, color: dataTextColor, fontFamily: Site.font),
            unselectedIconTheme: IconThemeData(size: dataIconSize, color: dataIconColor ?? dataTextColor),
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


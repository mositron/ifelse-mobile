import 'package:flutter/material.dart';
import '../site.dart';
import '../convert/icon.dart';
import '../convert/util.dart';
import '../convert/gradient.dart';

TabBar getTabBar(BuildContext buildContext, TabController _tabController, dynamic tabObj, Function tabClick) {
  if ((tabObj != null) && (tabObj is Map)) {
    dynamic data = getVal(tabObj,'data'),
      hover = getVal(tabObj,'hover'),
      items = getVal(data,'items'),
      indicator = getVal(data,'indicator');
    List<Tab> _item = [];      
    String spec = getVal(tabObj,'spec') ?? 'all';
    String iconColor = getVal(data,'icon.color') ?? '';
    String ipos = getVal(data,'icon.ipos') ?? '';
    Color dataTextColor = getColor(getVal(data,'text.color'),'000');
    double dataTextSize = getDouble(getVal(data,'text.size'),Site.fontSize);
    Color dataIconColor = iconColor.isNotEmpty ? getColor(iconColor,'000') : null;
    double dataIconSize = getDouble(getVal(data,'icon.size'),Site.fontSize);
    Color hoverTextColor = getColor(getVal(hover,'text.color'),'000');
    double hoverTextSize = getDouble(getVal(hover,'text.size'),Site.fontSize);
    String indicatorStyle = getVal(indicator,'style') ?? 'line';
    Gradient indicatorGradient = getGradient(getVal(indicator,'gradient'));
    Color indicatorColor = getColor(getVal(indicator,'color'));
    double indicatorHeight = getDouble(getVal(indicator,'height'),1);
    Map radius = getVal(indicator,'radius');
    BorderRadius indicatorRadius = BorderRadius.only(
      topLeft: Radius.circular(getDouble(radius['top'])),
      topRight: Radius.circular(getDouble(radius['right'])),
      bottomRight: Radius.circular(getDouble(radius['bottom'])),
      bottomLeft: Radius.circular(getDouble(radius['left'])),
    );
    if((items != null) && (items is List)) {
      for(int i=0; i<items.length; i++) {
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
        //Text _title = Text(v['text']);
        _item.add(
          Tab(
            //icon: _icon,
            child: Container(
              padding: EdgeInsets.fromLTRB(20,0,20,0),
              decoration: BoxDecoration(borderRadius: indicatorRadius),
              child: Align(
                alignment: Alignment.center,
                child: ipos == 'up' ?
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
                  )
              ),
            ),
          )
        );
      }
    }
    if(_item.length >= 2) {
      //TabBarIndicatorSize.tab
      Decoration idc;
      if(indicatorStyle == 'bg') {
        idc = BoxDecoration(
          gradient: indicatorGradient,
          borderRadius: indicatorRadius,
        );
      }
      print(indicatorHeight);
      return TabBar(
        tabs: _item,
        indicatorPadding: EdgeInsets.all(0),
        labelPadding: EdgeInsets.fromLTRB(10,0,10,0),
        isScrollable: true,
        indicatorSize: indicatorStyle == 'bg' ? TabBarIndicatorSize.label : TabBarIndicatorSize.tab,
        indicatorWeight: indicatorStyle == 'bg' ? 0 : indicatorHeight,
        indicatorColor: indicatorStyle == 'bg' ? null : indicatorColor,
        indicator: idc,
        controller: _tabController,
        labelColor: hoverTextColor,
        unselectedLabelColor: dataTextColor,
        labelStyle: TextStyle(fontSize: hoverTextSize, fontFamily: Site.font),
        unselectedLabelStyle: TextStyle(fontSize: dataTextSize, fontFamily: Site.font),
        //type: BottomNavigationBarType.fixed,
        // backgroundColor: Colors.transparent,
        /*
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
        */
        onTap: (index) {
          
        },
      );
    }
  }
  return null;
}


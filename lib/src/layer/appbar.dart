import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/icon.dart';
import 'package:ifelse/src/convert/image.dart';
//import '../convert/edge.dart';
import '../convert/gradient.dart';
import '../convert/util.dart';

AppBar getAppbar(dynamic obj, BuildContext buildContext) {
  if ((obj != null) && !(obj is List)) {
    dynamic box = getVal(obj,'box'),
      data = getVal(obj,'data'),
      logo = getVal(data,'logo'),
      nav = getVal(data,'nav'),
      action = getVal(data,'action');
    String logoStyle = getVal(logo,'style'),
      navStyle = getVal(nav,'style');
    Widget _title, _leading;
    if(logoStyle == 'text') {
      _title = Text(
        getVal(logo, 'text') ?? '',
        style: TextStyle(fontFamily: 'Kanit',fontSize: getDouble(getVal(logo,'size'), 16),color: getColor(getVal(logo,'color'),'fff'))
      );
    } else if(logoStyle == 'image') {
      _title = Image.network(getImage(getVal(logo,'image'),'s'));
    }
    if(navStyle == 'drawer') {
      _leading = IconButton(
        icon: Icon(
          getIcon(getVal(nav,'icon')),
          color: getColor(getVal(nav,'color'),'000'),
          size: getDouble(getVal(nav,'size'),16),
        ),      
        onPressed: () {},
      );
    }

    return AppBar(
      title: _title,
      centerTitle: getVal(logo,'align') == 'center',
      leading: _leading,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        //padding: getEdgeInset(getVal(box,'padding')),
       // margin: getEdgeInset(obj['box']['margin']),
        decoration: BoxDecoration(
          gradient: getGradient(getVal(box,'bg.color')),
          image: getImageBG(getVal(box,'bg')),          
        )
      ),
      actions:
          null, /*<Widget>[
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          tooltip: 'Next choice',
          onPressed: () {},
        ),
      ],*/

      /*
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48.0),
        child: Theme(
          data: Theme.of(buildContext).copyWith(accentColor: Colors.white),
          child: Container(
            height: 48.0,
            alignment: Alignment.center,
            child: TabPageSelector(controller: null),
          ),
        ),
      ),
      */
    );
  }
  return null;
}

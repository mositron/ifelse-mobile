import 'package:flutter/material.dart';
//import '../convert/edge.dart';
import '../convert/gradient.dart';
import '../convert/util.dart';

AppBar getAppbar(dynamic obj, BuildContext buildContext) {
  if ((obj != null) && !(obj is List)) {
    dynamic box = getVal(obj,'box');
    dynamic heading = getVal(obj,'heading');
    return AppBar(
      //automaticallyImplyLeading: false,
      title: Text(
        getVal(heading, 'text') ?? '',
        style: TextStyle(fontFamily: 'Kanit',fontSize: getDouble(getVal(heading,'size'), 16),color: getColor(getVal(heading,'color'),'fff'))
      ), //obj['data']['text'],
      leading: IconButton(
        tooltip: 'Previous choice',
        icon: const Icon(Icons.arrow_back),
        onPressed: () {},
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        //padding: getEdgeInset(getVal(box,'padding')),
       // margin: getEdgeInset(obj['box']['margin']),
        decoration: BoxDecoration(gradient: getGradient(getVal(box,'bg.color')))
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

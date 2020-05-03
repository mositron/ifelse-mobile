import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/edge.dart';
import 'package:ifelse/src/convert/gradient.dart';

AppBar getAppbar(dynamic obj, BuildContext buildContext) {
  if ((obj != null) && !(obj is List)) {
    return AppBar(
      //automaticallyImplyLeading: false,
      title: Text('ทดสอบ'), //obj['data']['text'],
      leading: IconButton(
        tooltip: 'Previous choice',
        icon: const Icon(Icons.arrow_back),
        onPressed: () {},
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        padding: getEdgeInset(obj['box']['padding']),
       // margin: getEdgeInset(obj['box']['margin']),
        decoration: BoxDecoration(gradient: getGradient(obj['box']['bg']['color']))
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

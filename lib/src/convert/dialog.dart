import 'package:flutter/material.dart';
import '../site.dart';

class IfDialog {
  static Future show({
    @required BuildContext context,
    String text,
    Widget container,
    Widget icon,
    Widget title,
  }) {
    Site.log.i(text);
    return showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)),
                title: title,
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(Icons.info_outline,color: Color(0xFFCCCCCC)),
                    Container(
                      height: 10,
                    ),
                    text != null ?
                      Text(text, style:TextStyle(fontFamily: 'Kanit')) :
                      widget
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    color: Colors.white,
                    child: Text('ปิด', style:TextStyle(fontFamily: 'Kanit')),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        }
      );
  }
}
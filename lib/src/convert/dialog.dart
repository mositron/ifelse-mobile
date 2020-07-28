import 'package:flutter/material.dart';
import '../site.dart';
import 'gradient.dart';

class IfDialog {
  bool _barrierDismissible = true;

  static Widget getLoading() {
    return Container(
        color: Colors.transparent,
        child: Center(
            child: Container(
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              gradient: getGradient({'color1': 'fff', 'color2': 'fff', 'range': 45, 'gragient': 2}),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
          ),
        )));
  }

  Future<bool> loading(BuildContext context) async {
    try {
      showDialog<dynamic>(
        context: context,
        barrierDismissible: _barrierDismissible,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () async => _barrierDismissible,
              child: Dialog(
                  child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
                    SizedBox(width: 20),
                    Text("Loading"),
                  ],
                ),
              )));
        },
      );
      await Future.delayed(Duration(milliseconds: 200));
      return true;
    } catch (err) {
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }

  static Future show({@required BuildContext context, String title, String text, String close}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: title != null ? Text('ยืนยันคำสั่งซื้อ', style: TextStyle(fontFamily: Site.font)) : null,
          content: Text(text, style: TextStyle(fontFamily: Site.font)),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text(close ?? 'ปิด', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Color(0xffff5717))),
            ),
          ],
        );
      },
    );
  }
}

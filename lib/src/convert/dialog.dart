import 'package:flutter/material.dart';
import '../site.dart';
import 'gradient.dart';

class IfDialog {
  bool _barrierDismissible = true;
  BuildContext _context, _dismissingContext;
  bool _isShowing = false;

  static Widget getLoading() {
    return Container(
        color: Colors.transparent,
        child: Center(
          child: Container(
            color: Colors.transparent,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: getGradient({'color1':'fff','color2':'fff','range':1,'gragient':2}),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),                      
              child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
            ),
        )
      )
    );
  }

  Future<bool> loading(BuildContext context) async {
    try {
      showDialog<dynamic>(
        context: context,
        barrierDismissible: _barrierDismissible,
        builder: (BuildContext context) {
          _dismissingContext = context;
          return WillPopScope(
            onWillPop: () async => _barrierDismissible,
            child: Dialog(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)),
                    SizedBox(width:20),
                    Text("Loading"),
                  ],
                ),
              )
            )
          );
        },
      );
      await Future.delayed(Duration(milliseconds: 200));
      _isShowing = true;
      return true;
    
    } catch (err) {
      _isShowing = false;
      debugPrint('Exception while showing the dialog');
      debugPrint(err.toString());
      return false;
    }
  }
  
  Future<bool> hide() async {
    try {
      if (_isShowing) {
        _isShowing = false;
        Navigator.of(_dismissingContext).pop();
        return Future.value(true);
      } else {
        return Future.value(false);
      }
    } catch (err) {
      debugPrint('...');
      debugPrint(err.toString());
      return Future.value(false);
    }
  }

  static Future show({@required BuildContext context, String text, Widget container, Widget icon, Widget title}) {
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
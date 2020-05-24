import 'package:flutter/material.dart';
import 'site.dart';
import 'layer.dart';
import 'convert/util.dart';

class BodyWidget extends StatefulWidget {
  final String file;
  final Map<String, dynamic> par;
  final Function func;
  BodyWidget({Key key, this.file, this.par, this.func}) : super(key: key);

  @override
  _BodyWidgetState createState() => new _BodyWidgetState(file, par, func);
}

class _BodyWidgetState extends State<BodyWidget> {
  String file;
  Map<String,dynamic> par = {};
  final Function func;
  _BodyWidgetState(this.file, this.par, this.func);

  @override
  Widget build(BuildContext buildContext) {
    if(Site.template[file] is List) {
      return Layer.buildBody(file, context, par, func);
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า 3 - '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: Site.font, fontSize: 24),
        )
      )    
    );
  }
}
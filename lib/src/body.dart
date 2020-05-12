import 'package:flutter/material.dart';
import 'site.dart';
import 'layer.dart';
import 'convert/util.dart';

class BodyWidget extends StatefulWidget {
  final String file;
  final Map<String, dynamic> par;
  BodyWidget({Key key, this.file, this.par}) : super(key: key);

  @override
  _BodyWidgetState createState() => new _BodyWidgetState(file, par);
}

class _BodyWidgetState extends State<BodyWidget> {
  String file;
  Map<String,dynamic> par = {};
  _BodyWidgetState(this.file, this.par);

  @override
  Widget build(BuildContext buildContext) {
    if(Site.template[file] is List) {
      //Site.log.i(file);
      return Layer.buildBody(file, context, par);
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า 3 - '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: 'Kanit', fontSize: 24),
        )
      )    
    );
  }
}
import 'package:flutter/material.dart';
import 'site.dart';
import 'layer.dart';
import 'convert/util.dart';

class BodyWidget extends StatefulWidget {
  final String file;
  final Map<String, dynamic> par;
  final Function func;
  final bool scroll;
  BodyWidget({Key key, this.file, this.par, this.func, this.scroll}) : super(key: key);

  @override
  BodyWidgetState createState() => new BodyWidgetState(file, par, func, scroll);
}

class BodyWidgetState extends State<BodyWidget> with AutomaticKeepAliveClientMixin  {
  String file;
  Map<String,dynamic> par = {};
  final Function func;
  final bool scroll;
  BodyWidgetState(this.file, this.par, this.func, this.scroll);

  @override
  bool get wantKeepAlive => true;
  
  @override
  void initState() {
    super.initState();  
  }

  @override
  Widget build(BuildContext buildContext) {
    if(Site.template[file] is List) {
      return SingleChildScrollView(
        child: Layer.buildBody(file, context, par, func)
      );
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
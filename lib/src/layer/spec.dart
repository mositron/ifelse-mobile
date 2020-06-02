import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../layer.dart';
import '../site.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../bloc/product.dart';

class SpecParser extends WidgetParser {
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    return new SpecView(key: UniqueKey(), map: map, buildContext: buildContext, par: par, func: func);    
  }
  
  @override
  String get widgetName => 'spec';
}

class SpecView extends StatefulWidget {
  final dynamic map;
  final BuildContext buildContext;
  final dynamic par;
  final Function func;
  SpecView({Key key, this.map, this.buildContext, this.par, this.func}) : super(key: key);

  @override
  _SpecViewState createState() {
    //print(_map);
    return new _SpecViewState(map, buildContext, par, func);
  }
}
 
class _SpecViewState extends State<SpecView> {
  bool loaded;
  dynamic _map;
  BuildContext buildContext;
  dynamic _par;
  Function _func;
  _SpecViewState(this._map, this.buildContext, this._par, this._func);


  @override
  Widget build(BuildContext context) {
    dynamic box = getVal(_map,'box'),
      data = getVal(_map,'data');
    int diff = getInt(getVal(_par,'diff'), 0);
    List<Widget> _spec = [];
    if(diff > 0) {
      int eachStyle = getInt(getVal(_par,'each.style'), 0);
      if(eachStyle > 0) {
        Map style1 = getVal(_par,'each.style1');
        String eachName1 = getString(getVal(style1, 'name'));
        dynamic style1Item = getVal(style1, 'item');
        List<Widget> _btn = [];
        if((style1Item != null) && (style1Item is List) && (style1Item.length > 0)) {
          int i = 0;
          style1Item.forEach((val) {
            if(val is Map) {
              final j = i;
              _btn.add(
                BlocBuilder<ProductBloc, Map>(
                  bloc: context.repository<ProductBloc>(),
                  builder: (_, product) {
                    return RaisedButton(
                      onPressed: () {
                        _func('spec',{'type':'style1', 'index': j});
                      },
                      color: product['style1'] == j ? Color(0xffe7e7e7) : Colors.white,
                      child: Text(getString(val['name']), style: TextStyle(color: Colors.black)),
                    );
                  }
                )
              );
            }
            i++;
          });
        }
        _spec.add(
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 50.0,
                    maxWidth: 100.0,
                  ),
                  child: Text(eachName1, style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(data,'size'), Site.fontSize),color: getColor(getVal(data,'color'))))
                ),
                ButtonBar(children: _btn),
              ]
            )
          ),
        );
      }
      if(eachStyle > 1) {
        Map style2 = getVal(_par,'each.style2');
        String eachName2 = getString(getVal(style2, 'name'));
        dynamic style2Item = getVal(style2, 'item');
        List<Widget> _btn = [];
        if((style2Item != null) && (style2Item is List) && (style2Item.length > 0)) {
          int i = 0;
          style2Item.forEach((val) {
            if(val is Map) {
              final j = i;
              _btn.add(
                BlocBuilder<ProductBloc, Map>(
                  bloc: context.repository<ProductBloc>(),
                  builder: (_, product) {
                    return RaisedButton(
                      onPressed: () {
                        _func('spec',{'type':'style2', 'index': j});
                      },
                      color: product['style2'] == j ? Color(0xffe7e7e7) : Colors.white,
                      child: Text(getString(val['name']), style: TextStyle(color: Colors.black)),
                    );
                  }
                )
              );
            }
            i++;
          });
        }

        _spec.add(
          Container(
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: Row(
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minWidth: 50.0,
                    maxWidth: 100.0,
                  ),
                  child: Text(eachName2, style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(data,'size'), Site.fontSize),color: getColor(getVal(data,'color'))))
                ),
                ButtonBar(children: _btn),
              ]
            )
          ),
        );
      }
      
      _spec.add(
        Container(
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: BlocBuilder<ProductBloc, Map>(
            bloc: context.repository<ProductBloc>(),
            builder: (_, product) {
              String txt = 'กรุณาเลือกสินค้า';
              if(eachStyle == 1) {
                if(product['style1'] > -1) {
                  if(product['stock'] > 0) {
                    txt = 'จำนวนสินค้าในคลัง ' + getString(product['stock']) + ' ' + getString(product['unit']);
                  } else {
                    txt = 'สินค้าหมด';
                  }
                }
              } else if(eachStyle == 2) {
                if((product['style1'] > -1) && (product['style2'] > -1)) {
                  if(product['stock'] > 0) {
                    txt = 'จำนวนสินค้าในคลัง ' + getString(product['stock']) + ' ' + getString(product['unit']);
                  } else {
                    txt = 'สินค้าหมด';
                  }
                }
              }
              return Text(txt, style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(data,'size'), Site.fontSize),color: getColor(getVal(data,'color'))));
            }
          )
        ),
      );
      
    }

    _spec.add(
      Container(
        margin: EdgeInsets.only(top:5, bottom:5),
        padding: EdgeInsets.all(0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            new SizedBox(
              width: 30,
              height: 30,
              child: RawMaterialButton(
                onPressed: (){
                  _func('spec',{'type': 'dec'});
                },
                elevation: 2,
                child: Icon(Icons.remove),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: 80,
              alignment: Alignment.center,
              child: BlocBuilder<ProductBloc, Map>(
                bloc: context.repository<ProductBloc>(),
                builder: (_, product) {
                  return Text(
                    product['amount'].toString(),
                    style: TextStyle(fontFamily: Site.font, color: Colors.black)
                  );
                }
              )
            ),
            SizedBox(
              width: 30,
              height: 30,
              child: RawMaterialButton(
                onPressed: () {
                  _func('spec',{'type': 'inc'});
                },
                elevation: 2,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      )
    );    
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      //padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: CustomPaint(
        //size: Size(viewportConstraints.maxWidth, viewportConstraints.maxHeight),
        painter: DrawCurve(getVal(box,'bg.color')),
        child: Container(
          padding: getEdgeInset(getVal(box,'padding')),
          child: Column(
            children: _spec
          )
        )
      )
    );
  }
}

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
import '../bloc/cart.dart';

class SpecParser extends WidgetParser {
  Widget parse(String file, Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par, Function func]) {
    return new SpecView(key: UniqueKey(), map: map, buildContext: buildContext, par: par);    
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
    //Site.log.w(_map);
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
    Site.productEachStyle = getInt(getVal(_par,'each.style'), 0);
    List<Widget> _spec = [];
    if(Site.productEachStyle > 0) {
      Map style1 = getVal(_par,'each.style1');
      Site.productEachName1 = getString(getVal(style1, 'name'));
      dynamic style1Item = getVal(style1, 'item');
      List<Widget> _btn = [];
      if((style1Item != null) && (style1Item is List) && (style1Item.length > 0)) {
        int i = 0;
        style1Item.forEach((val) {
          if(val is Map) {
            final j = i;
            _btn.add(
              BlocBuilder<CartBloc, int>(
                bloc: Site.cartBloc,
                builder: (_, count) {
                  return RaisedButton(
                    onPressed: () {
                      setState(() {
                        Site.productEachStyle1 = j;
                      });
                    },
                    color: Site.productEachStyle1 == j ? Color(0xffe7e7e7) : Colors.white,
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
                child: Text(Site.productEachName1, style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(data,'size'), Site.fontSize),color: getColor(getVal(data,'color'))))
              ),
              ButtonBar(children: _btn),
            ]
          )
        ),
      );
    }
    if(Site.productEachStyle > 1) {
      Map style2 = getVal(_par,'each.style2');
      Site.productEachName2 = getString(getVal(style2, 'name'));
      dynamic style2Item = getVal(style2, 'item');
      List<Widget> _btn = [];
      if((style2Item != null) && (style2Item is List) && (style2Item.length > 0)) {
        int i = 0;
        style2Item.forEach((val) {
          if(val is Map) {
            final j = i;
            _btn.add(
              BlocBuilder<CartBloc, int>(
                bloc: Site.cartBloc,
                builder: (_, count) {
                  return RaisedButton(
                    onPressed: () {
                      setState(() {
                        Site.productEachStyle2 = j;
                      });
                    },
                    color: Site.productEachStyle2 == j ? Color(0xffe7e7e7) : Colors.white,
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
                child: Text(Site.productEachName2, style: TextStyle(fontFamily: Site.font,fontSize: getDouble(getVal(data,'size'), Site.fontSize),color: getColor(getVal(data,'color'))))
              ),
              ButtonBar(children: _btn),
            ]
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
                  setState(() {
                    if(Site.productAmount > 1) {
                      Site.productAmount--;
                    }
                  });
                },
                elevation: 2,
                child: Icon(Icons.remove),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              width: 80,
              alignment: Alignment.center,
              child: BlocBuilder<CartBloc, int>(
                bloc: Site.cartBloc,
                builder: (_, count) {
                  return Text(
                    Site.productAmount.toString(),
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
                  setState(() {
                    Site.productAmount++;
                  });
                },
                elevation: 2,
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
      )
    );
    
    print(_par['each']);
    return Container(
      decoration: BoxDecoration(
        gradient: getGradient(getVal(box,'bg.color')),
        borderRadius: getBorderRadius(getVal(box,'border')),
        boxShadow: getBoxShadow(getVal(box,'shadow')),
      ),
      margin: getEdgeInset(getVal(box,'margin')),
      padding: getEdgeInset(getVal(box,'padding')),
      alignment: Alignment(0.0, 0.0),
      child: Column(
        children: _spec
      ,
      )
    );
  }
  /*
'<div class="layer-spec'.$btn.' layer-spec-<?php echo $this->page[\'_id\']?>" data-product="<?php echo $this->page[\'_id\']?>">'.
        '<?php if(is_array($this->page[\'each\']) && ($this->page[\'each\'][\'style\'])):?>'.
          '<?php if((is_array($this->page[\'each\'][\'style1\'])) && '.
          '(is_array($this->page[\'each\'][\'style1\'][\'item\'])) && '.
          '(count($this->page[\'each\'][\'style1\'][\'item\']))):?>'.
            '<div class="row">'.
              '<div class="col-auto w-flex-100 text-truncate py-1"><?php echo $this->page[\'each\'][\'style1\'][\'name\']?></div>'.
              '<div class="col layer-spec-style1">'.
              '<?php foreach($this->page[\'each\'][\'style1\'][\'item\'] as $i=>$item):?>'.
                '<div class="layer-spec-button disabled" data-style="1" data-index="<?php echo $i?>" onclick="_.cart.select(this)"><?php echo $item[\'name\']?></div>'.
              '<?php endforeach?>'.
              '</div>'.
            '</div>'.
          '<?php endif?>'.
          '<?php if($this->page[\'each\'][\'style\']==2):?>'.
            '<?php if((is_array($this->page[\'each\'][\'style2\'])) && '.
            '(is_array($this->page[\'each\'][\'style2\'][\'item\'])) && '.
            '(count($this->page[\'each\'][\'style2\'][\'item\']))):?>'.
              '<div class="row mt-2">'.
                '<div class="col-auto w-flex-100 text-truncate py-1"><?php echo $this->page[\'each\'][\'style2\'][\'name\']?></div>'.
                '<div class="col layer-spec-style2">'.
                '<?php foreach($this->page[\'each\'][\'style2\'][\'item\'] as $i=>$item):?>'.
                  '<div class="layer-spec-button disabled" data-style="2" data-index="<?php echo $i?>" onclick="_.cart.select(this)"><?php echo $item[\'name\']?></div>'.
                '<?php endforeach?>'.
                '</div>'.
              '</div>'.
            '<?php endif?>'.
          '<?php endif?>'.
        '<?php endif?>'.
        '<?php if($this->spec[\'status\'] == 1):?>'.
          '<div class="row mt-2">'.
            '<div class="col-auto w-flex-100 text-truncate"></div>'.
            '<div class="col"><span class="layer-spec-status1">'.$status1['text'].'</span></div>'.
          '</div>'.
        '<?php elseif($this->spec[\'status\'] == 2):?>'.
          '<div class="row mt-2">'.
            '<div class="col-auto w-flex-100 text-truncate"></div>'.
            '<div class="col"><span class="layer-spec-status2">'.$status2['text'].'</span></div>'.
          '</div>'.
        '<?php elseif($this->spec[\'status\'] == 3):?>'.
          '<div class="row mt-2">'.
            '<div class="col-auto w-flex-100 text-truncate"></div>'.
            '<div class="col"><span class="layer-spec-status3">'.$status3['text'].'</span></div>'.
          '</div>'.
        '<?php elseif((!$this->spec[\'status\']) && (!$this->spec[\'download\'])):?>'.
          '<div class="row mt-2">'.
            '<div class="col-auto w-flex-100 text-truncate">จำนวน</div>'.
            '<div class="col">'.
                '<div class="layer-spec-action">'.
                  '<div><i class="icofont-minus"></i><input type="text" value="1" /><i class="icofont-plus"></i></div>'.
                '</div>'.
                '<span>มีสินค้าทั้งหมด</span> <span class="layer-spec-amount"></span> <span><?php echo $this->page[\'dim\'][\'unit\']?></span>'.
            '</div>'.
          '</div>'.
        '<?php endif?>'.
      '</div>'.
      '<script>'.
        '$(function(){_.cart.spec(<?php echo $this->page[\'_id\']?>,<?php echo json_encode(is_array($this->spec)?$this->spec:[])?>);})'.
      '</script>';
  */
}

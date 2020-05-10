import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/image.dart';
import 'util.dart';
import '../site.dart';

List<Widget> getEditor(dynamic data) {
  List<Widget> widget = [];
  if ((data is Map) && (data['blocks'] is List)) {
    data['blocks'].forEach((v){
      switch(v['type']) {
        case 'paragraph':
          widget.add(editorParagraph(v));
          break;
        case 'heading':
        case 'header':
          widget.add(editorHeading(v));
          break;
        case 'image':
          widget.add(editorImage(v));
          break;
        case 'list':
        case 'delimiter':
        case 'embed':
        case 'table':
        case 'code':
        case 'youtube':
        case 'divider':
      }
    });
  }
  return widget;
}

Widget editorParagraph(Map block) {
  return Container(
    margin: EdgeInsets.only(bottom:15),
    alignment: Alignment.centerLeft,
    child: Text(block['data']['text'], style: TextStyle(fontSize: 16, fontFamily:'Kanit'))
  );
}

Widget editorHeading(Map block) {
  Map<int,double> size = {0:16,1:40,2:32,3:28,4:24,5:20,6:16};
  return Container(
    margin: EdgeInsets.only(bottom:15),
    alignment: Alignment.centerLeft,
    child: Text(block['data']['text'], style: TextStyle(fontSize: size[getInt(getVal(block,'data.level')??0)], fontFamily:'Kanit'))
  );
}

Widget editorImage(Map block) {
  Map image = getImageObj(getVal(block,'data.image'),'o');
  return Container(
    margin: EdgeInsets.only(bottom:15),
    alignment: Alignment.centerLeft,
      child: image != null ? 
        getImageWidget(image['src']) : 
        null,
  );
}

/*

    $html = '';
    if(is_array($block['data'])) {
      if(is_array($block['data']['image'])) {
        $cls = [];
        if(in_array($block['data']['align'],['left','center','right'])) {
          $cls[] = 'text-'.$block['data']['align'];
        }
        $c = [];
        if($block['data']['rounded']) {
          $c[] = 'rounded';
        }
        if($block['data']['border']) {
          $c[] = 'border';
        }
        if($block['data']['shadow']) {
          $c[] = 'shadow';
        }
        $a1 = $a2 = '';
        $click = intval($block['data']['click']);
        if($click == 2) {
          $cls[] = 'layer-lightbox layer-lightbox-item';
        } elseif($click == 1) {
          $url = $this->str($block['data']['url'],false);
          $a1 = '<a href="'.$url.'">';
          $a2 = '</a>';
        }
        $img = Load::getImage($block['data']['image'],'o',null,true);
        $html = '<figure'.(count($cls)?' class="'.implode(' ',$cls).'"':'').'>'.$a1.'<img data-src="'.$img['src'].'" data-color="'.$img['color'].'"'.($img['width']?' width="'.$img['width'].'"':'').''.($img['height']?' height="'.$img['height'].'"':'').''.(count($c)?' class="'.implode(' ',$c).'"':'').'>'.$a2.'</figure>';
      }
    }
*/
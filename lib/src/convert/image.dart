import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'align.dart';
import 'util.dart';
import '../site.dart';

String getImage(dynamic obj, [String size, String service]) {
  if ((obj != null) && (obj is Map)) {
    size ??= 'o';
    if (obj[size] == null) {
      size = 'o';
    }
    if (obj[size] != null) {
      return 'https://' + (obj['server'] ?? 'f1') + '.ifelse.co/' + 
              (service ?? 'site') + '/' + obj['path']  + '/' + obj['_id'].toString() + '/' +
              obj['key'] + (size != 'o'?'-'+size:'') + '.' + (obj[size]['ext'] ?? obj['ext']);
    }
  }
  return null;
}

dynamic getImageObj(dynamic obj, [String size, String service]) {
  if ((obj != null) && (obj is Map)) {
    size ??= 'o';
    if (obj[size] == null) {
      size = 'o';
    }
    if (obj[size] != null) {      
      return {
        'src': 'https://' + (obj['server'] ?? 'f1') + '.ifelse.co/' + 
              (service ?? 'site') + '/' + obj['path']  + '/' + obj['_id'].toString() + '/' +
              obj['key'] + (size != 'o'?'-'+size:'') + '.' + (obj[size]['ext'] ?? obj['ext']),
        'ext': (obj[size]['ext'] ?? obj['ext']),
        'size': size,
        'width': getDouble(obj[size]['w']),
        'height': getDouble(obj[size]['h']),
      };
    }
  }
  return null;
}

DecorationImage getImageBG(dynamic obj) {
  if ((obj != null) && (obj is Map)) {
    dynamic img =  getImageObj(obj['image'],'o');
    BoxFit bfit = BoxFit.none;
    switch(obj['size'].toString()) {
      case 'cover':
        bfit = BoxFit.cover;
        break;
      case 'contain':
        bfit = BoxFit.contain;
        break;
    }
    if(img != null) {
      return DecorationImage(
        image: Image.network(img['src'], width: img['width'], height: img['height']).image,
        fit: bfit,
        alignment: getAlign(obj['pos']),
        repeat:obj['size'].toString().isNotEmpty ? ImageRepeat.repeat : ImageRepeat.noRepeat
      );
    }
  }
  return null;
}

Widget getImageWidget(String src) {
  if(src.isNotEmpty) {
    return CachedNetworkImage(
      imageUrl: src,
      alignment: Alignment.topCenter,
      fit: BoxFit.cover,
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return Center(
          child: Container(
            padding: EdgeInsets.all(30),
            width: 100,
            height: 100,
            alignment: Alignment.center,
            child: CircularProgressIndicator(value: downloadProgress.progress)
          )
        );
      },
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
  return null;
}

Widget getImageRatio(dynamic obj, String size, double ratio) {
  if ((obj != null) && (obj is Map)) {
    dynamic img =  getImageObj(obj, size);
    if(img != null) {
      if(ratio > 0) {
        //Site.log.i(img);
        return AspectRatio(
          aspectRatio: ratio,
            child: ClipRect(
              child:OverflowBox(
                alignment: Alignment.center,
                child: new FittedBox(
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  child: new Container(
                    child: getImageWidget(img['src'])
                  )
                )
              )
            )
          );
      } else {
        return getImageWidget(img['src']);
      }
    }
  }
  return null;
}
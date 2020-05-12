
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../layer.dart';
import '../site.dart';
import '../convert/image.dart';
import '../convert/gradient.dart';
import '../convert/shadow.dart';
import '../convert/border.dart';
import '../convert/edge.dart';
import '../convert/util.dart';
import '../convert/align.dart';

class GalleryParser extends WidgetParser {
  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext, [Map<String, dynamic> par]) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      col = getVal(data,'col');
    int colMb = getInt(getVal(col,'mb'),1);//,
     // colTl = getInt(getVal(col,'tl'),2);
    String colDirect = getVal(col,'direct').toString();
    double colHeight  = getDouble(getVal(col,'height'),200),
      ratio = getRatio(getVal(data,'ratio'));
      
      Site.log.e(colDirect);

    EdgeInsets contentPadding = getEdgeInset(getVal(data,'box.padding'));
    if(par['gallery'] is List) {
      List<dynamic> gallery = par['gallery'];
      List<Widget> photo = [];
      if(gallery.length > 0) {
        gallery.forEach((v) {
          String img = getImage(v['image'],'t');
          if(img != null) {
            photo.add(
              Container(
                padding: contentPadding,
                height: colHeight,
                width: ratio > 0 ? ratio * colHeight : null,
                child: ratio > 0 ?
                  AspectRatio(
                    aspectRatio: ratio,
                    child: getImageWidget(img),
                  ) :
                  getImageWidget(img)
              )
            );    
          }
        });
      }
      if(photo.length > 0) {
        return Container(
          decoration: BoxDecoration(
            gradient: getGradient(getVal(box,'bg.color')),
            borderRadius: getBorderRadius(getVal(box,'border')),
            boxShadow: getBoxShadow(getVal(box,'shadow')),
          ),
          margin: getEdgeInset(getVal(box,'margin')),
          padding: getEdgeInset(getVal(box,'padding')),
          alignment: getAlignBox(getVal(data,'align')),
          //width: double.infinity,
          height: colDirect == 'horizon' ? colHeight : null,
          child: StaggeredGridView.countBuilder(
            primary: false,
            //addAutomaticKeepAlives: true,
            crossAxisCount: colDirect == 'horizon' ? 1 : colMb,
            mainAxisSpacing: 0,
            crossAxisSpacing: 0,
            scrollDirection: colDirect == 'horizon' ? Axis.horizontal : Axis.vertical,
            itemCount: photo.length,
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                child: photo[index],
                onTap: () => {},
              );
            },
            staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
          )
        );
      }
    }
    return Container();
  }
  @override
  String get widgetName => 'gallery';
}

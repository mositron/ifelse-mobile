import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../site.dart';
import 'api.dart';
import 'align.dart';
import 'image.dart';
import 'gradient.dart';
import 'border.dart';
import 'edge.dart';
import 'shadow.dart';
import 'util.dart';
 
class Product {
  static Future<List<ProductModel>> getList(dynamic map) async {
    final Map response = await Api.call('products', {
        'category': map['category'].toString(),
        'status': map['status'].toString(),
        'tag': map['tag'].toString(),
        'order': map['order'].toString(),
        'skip': map['skip'].toString(),
        'limit': map['limit'].toString(),
      });
    if((response is Map) && (response['products'] is List)) {
      final List<ProductModel> list = parsePostsForGrid(response['products']);
      return list;
    }
    return null;
  }

  static Future<Map> getProduct(int id) async {
    final Map response = await Api.call('product', {
        'id': id.toString(),
      });
    if((response is Map) && (response['product'] is Map)) {
      return response['product'];
    }
    return null;
  }

  static List<ProductModel> parsePostsForGrid(List body) {
    try {
      if((body != null) && (body != null)) {
        return body.map<ProductModel>((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
  
  static Widget getGrid(AsyncSnapshot<List<ProductModel>> snapshot, dynamic map, Function gridClicked) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      dataBox = getVal(data,'box');
    int colMb = getInt(getVal(data,'col.mb'),2);
    EdgeInsets padding = getEdgeInset(getVal(dataBox,'padding')),
      margin = getEdgeInset(getVal(dataBox,'margin')),
      contentPadding = getEdgeInset(getVal(data,'content.padding'));
    TextAlign contentAlign = getAlignText(getVal(data,'content.align'));
    int contentLine = getInt(getVal(data,'content.line'),0);
    String align = getVal(data,'align').toString();
    double width  = getDouble(getVal(data,'width'),80),
      ratio = getRatio(getVal(data,'ratio'));
    Border border = getBorder(getVal(dataBox,'border'));
    BorderRadius radius = getBorderRadius(getVal(dataBox,'border'));
    List<BoxShadow> boxShadow = getBoxShadow(getVal(dataBox,'shadow'));
    Gradient gradient  = getGradient(getVal(dataBox,'bg.color'));
    Color textColor  = getColor(getVal(data,'color'),'000');
    double textSize  = getDouble(getVal(data,'fsize'),Site.fontSize);    
    String colDirect = getVal(data,'col.direct').toString();
    double colHeight  = getDouble(getVal(data,'col.height'),200);
    dynamic normal = getVal(data,'price.normal');
    Color normalColor  = getColor(getVal(normal,'color'),'000');
    double normalSize  = getDouble(getVal(normal,'size'),Site.fontSize);    
    dynamic over = getVal(data,'price.over');
    Color overColor  = getColor(getVal(over,'color'),'000');
    double overSize  = getDouble(getVal(over,'size'),14);    

    if(width < 50) {
      width = 50;
    }

    try {
      //Site.log.i(colDirect);
      //Site.log.i(colHeight);
      return  Container(
        alignment: Alignment.center,    
        decoration: BoxDecoration(
          gradient: getGradient(getVal(box,'bg.color')),
          borderRadius: getBorderRadius(getVal(box,'border')),
          border: getBorder(getVal(box,'border')),
          boxShadow: getBoxShadow(getVal(box,'shadow')),
        ),
        margin: getEdgeInset(getVal(box,'margin')),
        padding: getEdgeInset(getVal(box,'padding')),
        width: double.infinity,
        height: colDirect == 'horizon' ? colHeight : null,
        child: StaggeredGridView.countBuilder(
          addRepaintBoundaries: true,
          primary: false,
          addAutomaticKeepAlives: true,
          crossAxisCount: colDirect == 'horizon' ? 1 : colMb,
          scrollDirection: colDirect == 'horizon' ? Axis.horizontal : Axis.vertical,
          itemCount: snapshot.data.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(0),
          
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              child: ProductCell(
                snapshot.data[index],
                padding,
                margin,
                border,
                radius,
                boxShadow,
                gradient,
                align,
                width,
                ratio,
                contentAlign,
                contentPadding,
                contentLine,
                textColor,
                textSize,
                normalColor,
                normalSize,
                overColor,
                overSize,
              ),
              onTap: () => gridClicked(snapshot.data[index]),
            );
          },
          staggeredTileBuilder: (int index) => (colDirect == 'horizon' ? StaggeredTile.extent(1,150) : StaggeredTile.fit(1)),
          mainAxisSpacing: 0,
          crossAxisSpacing: 0,
        )
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
 
  static Widget circularProgress() {
    return Container(
      padding: EdgeInsets.all(20),
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent)
      )
    );
  }

  static FlatButton retryButton(Function fetch) {
    return FlatButton(
      child: Text(
        "No Internet Connection.\nPlease Retry",
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontWeight: FontWeight.normal),
      ),
      onPressed: () => fetch(),
    );
  }
}

class ProductModel {
  String id;
  String title;
  String url;
  Map image; 
  int diff; 
  List<double> price; 
  ProductModel({this.id, this.title, this.url, this.image, this.price, this.diff}); 
  factory ProductModel.fromJson(Map<String, dynamic> json) {    
    List<double> _price = [0, 0]; 
    if(json['price'] is List) {
      List<dynamic> price = json['price'];
      if(price.length == 2) {
        _price = [getDouble(price[0]), getDouble(price[1])];
      }
    }
    try {      
      return new ProductModel(
        id: json['_id'].toString(),
        title: json['title'].toString(),
        url: json['link'].toString(),
        image: getVal(json,'image'),
        //image: getImageObj(getVal(json,'image')),
        diff: getInt(json['diff']),
        price: _price,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

class ProductCell extends StatelessWidget {
  const ProductCell(
    this.cellProduct,this.padding,this.margin,this.border,this.radius,this.shadow,this.gradient,  
    this.align,this.width,this.ratio,this.contentAlign,this.contentPadding,this.contentLine,
    this.textColor,this.textSize,this.normalColor,this.normalSize,this.overColor,this.overSize
  );
  @required
  final ProductModel cellProduct;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border border;
  final BorderRadius radius;
  final List<BoxShadow> shadow;
  final Gradient gradient;
  final String align;
  final double width;
  final double ratio;
  final TextAlign contentAlign;
  final EdgeInsets contentPadding;
  final int contentLine;
  final Color textColor;
  final double textSize;
  final Color normalColor;
  final double normalSize;
  final Color overColor;
  final double overSize;
 
  @override
  Widget build(BuildContext context) {
    //Site.log.e(ratio);
    Widget _image = getImageRatio(cellProduct.image,'t',ratio);

      List<Widget> _detail = [
        Container( 
            child: Text(
                  cellProduct.title,
                  textAlign: contentAlign,
                  overflow: TextOverflow.ellipsis,
                  maxLines: contentLine > 0 ? contentLine : 5,
                  style: TextStyle(color: textColor, fontSize: textSize, fontFamily:Site.font, height: 1.5),
            )
          ), 
      ];

    if(cellProduct.diff > 0) {
      if(cellProduct.price[0] > 0 && cellProduct.price[1] > 0) {
        _detail.add(
          Container(
            margin: EdgeInsets.only(top:5),
            child: Text.rich(
              TextSpan(
                text: '฿' + getCurrency(cellProduct.price[0]),
                style: TextStyle(color: normalColor,fontSize: normalSize),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' ~ ',  
                    style: TextStyle(color: normalColor,fontSize: normalSize),
                  ),
                  TextSpan(
                    text: '฿' + getCurrency(cellProduct.price[1]),             
                    style: TextStyle(color: normalColor,fontSize: normalSize),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          )
        );
      } else if(cellProduct.price[1] > 0) {
        _detail.add(
          Container(
            margin: EdgeInsets.only(top:5),
            child: Text.rich(
              TextSpan(
                text: '฿' + getCurrency(cellProduct.price[1]),
                style: TextStyle(color: normalColor,fontSize: normalSize),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          )
        );
      }
    } else {
      if(cellProduct.price[0] > 0 && cellProduct.price[1] > 0) {
        _detail.add(
          Container(
            margin: EdgeInsets.only(top:5),
            child: Text.rich(
              TextSpan(
                text: '฿' + getCurrency(cellProduct.price[0]),
                style: TextStyle(color: normalColor,fontSize: normalSize),
                children: <InlineSpan>[
                  TextSpan(
                    text: ' ',  
                    style: TextStyle(color: Color(0xffffffff),fontSize: normalSize),
                  ),
                  TextSpan(
                    text: '฿' + getCurrency(cellProduct.price[1]),             
                    style: TextStyle(color: overColor,fontSize: overSize, decoration: TextDecoration.lineThrough),
                  ),
                ],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          )
        );
      } else if(cellProduct.price[1] > 0) {
        _detail.add(
          Container(
            margin: EdgeInsets.only(top:5),
            child: Text.rich(
              TextSpan(
                text: '฿' + getCurrency(cellProduct.price[1]),
                style: TextStyle(color: Color(0xffffffff),fontSize: Site.fontSize),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          )
        );
      }
    }

    Widget _content = Container(
      padding: contentPadding,       
      margin: EdgeInsets.all(0),
      child: Column(
        children: _detail,        
      )
    );

    Widget _child;
    if(align == 'left') {
      _child = Row(            
        children: [
          Container(width: width, child: _image,),
          Expanded(child: _content),
        ],
      );
    } else if(align == 'right') {
      _child = Row(            
        children: [
          Expanded(child: _content),
          Container(width: width, child: _image),
        ],
      );
    } else {
      _child = Column(       
        crossAxisAlignment: CrossAxisAlignment.center,     
        children: [_image, _content],
      );
    }
    try {
      return Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: radius,
          boxShadow: shadow,
        ),
        margin: margin,
        padding: padding,
        child: _child,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
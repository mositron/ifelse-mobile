import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../site.dart';
import 'image.dart';
import 'gradient.dart';
import 'border.dart';
import 'edge.dart';
import 'shadow.dart';
import 'util.dart';
 
class COLORS {
  static const Color DRAWER_BG_COLOR = Colors.lightGreen;
  static const Color APP_THEME_COLOR = Colors.green;
}

class Article {
  static Future<List<CellModel>> getData(dynamic map) async {
    dynamic data = getVal(map,'data');
    final client = new http.Client();
    final response = await client.post(
      Site.api + 'articles',
      headers: {'user-agent': 'ifelse.co-'+Site.version},
      body: {
        'token': Site.token,
        'session': Site.session,
        'skip': getInt(getVal(data,'skip'), 0).toString(),
        'limit': getInt(getVal(data,'limit'), 6).toString(),
      }
    );
    try {
      if (response.statusCode == 200) {
        final List<CellModel> list = parsePostsForHome(response.body);
        return list;
      } else {
        throw Exception("No Internet Connection.\nPlease Retry");
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  static List<CellModel> parsePostsForHome(String responseBody) {
    try {
      final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();    
      return parsed.map<CellModel>((json) => CellModel.fromJson(json)).toList();
    } catch (e) {
      //Site.log.w(e.toString());
      throw Exception(e.toString());
    }
  }
  
  static Widget getGrid(AsyncSnapshot<List<CellModel>> snapshot, dynamic map, Function gridClicked) {
    dynamic box = getVal(map,'box'),
      data = getVal(map,'data'),
      dataBox = getVal(data,'box');
    int colMb = getInt(getVal(data,'col.mb'),2);
    EdgeInsets padding = getEdgeInset(getVal(dataBox,'padding')),
      margin = getEdgeInset(getVal(dataBox,'margin')),
      contentPadding = getEdgeInset(getVal(data,'content.padding'));
    Border border = getBorder(getVal(dataBox,'border'));
    BorderRadius radius = getBorderRadius(getVal(dataBox,'border'));
    List<BoxShadow> boxShadow = getBoxShadow(getVal(dataBox,'shadow'));
    Gradient gradient  = getGradient(getVal(dataBox,'bg.color'));
    Color textColor  = getColor(getVal(data,'color'),'000');
    double textSize  = getDouble(getVal(data,'fsize'),16);
    try {
      //Site.log.i(box);
      return Container(
        alignment: Alignment.center,    
        decoration: BoxDecoration(
          gradient: getGradient(getVal(box,'bg.color')),
          borderRadius: getBorderRadius(getVal(box,'border')),
          border: getBorder(getVal(box,'border')),
          boxShadow: getBoxShadow(getVal(box,'shadow')),
        ),
        margin: getEdgeInset(getVal(box,'margin')),
        padding: getEdgeInset(getVal(box,'padding')),
        child: StaggeredGridView.countBuilder(
          primary: false,
          crossAxisCount: colMb,
          itemCount: snapshot.data.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) => Cell(
              snapshot.data[index],
              padding,
              margin,
              border,
              radius,
              boxShadow,
              gradient,
              contentPadding,
              textColor,
              textSize,
            ),
          staggeredTileBuilder: (int index) => new StaggeredTile.fit(1),
          mainAxisSpacing: 4.0,
          crossAxisSpacing: 4.0,
        )
      );
    } catch (e) {
      //Site.log.w(e.toString());
      throw Exception(e.toString());
    }
  }
 
  static CircularProgressIndicator circularProgress() {
    return CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(COLORS.APP_THEME_COLOR),
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

class CellModel {
  String id;
  String title;
  String url;
  dynamic image;
 
  CellModel({this.id, this.title, this.url, this.image});
 
  factory CellModel.fromJson(Map<String, dynamic> json) {
    try {
      return new CellModel(
        id: json['_id'].toString(),
        title: json['title'].toString(),
        url: json['link'].toString(),
        image: getImageObj(getVal(json,'image'), 't')
      );
    } catch (e) {
      //Site.log.w(e.toString());
      throw Exception(e.toString());
    }
  }
}

class Cell extends StatelessWidget {
  const Cell(this.cellModel,this.padding,this.margin,this.border,this.radius,this.shadow,this.gradient,this.contentPadding,this.textColor,this.textSize);
  @required
  final CellModel cellModel;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Border border;
  final BorderRadius radius;
  final List<BoxShadow> shadow;
  final Gradient gradient;
  final EdgeInsets contentPadding;
  final Color textColor;
  final double textSize;
 
  @override
  Widget build(BuildContext context) {
    try {
      return Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: radius,
            boxShadow: shadow,
          ),
          margin: margin,
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AspectRatio(
                aspectRatio: 3 / 2,
                child: Image.network(
                  cellModel.image['src'],
                  width: cellModel.image['width'],
                  height: cellModel.image['height'],
                  alignment: Alignment.topCenter,
                  fit: BoxFit.fitHeight),
              ),
              Padding(
                padding: contentPadding,
                child: Text(
                  cellModel.title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                  style: TextStyle(color: textColor, fontSize: textSize, fontFamily:'Kanit', height: 1.5),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      //Site.log.w(e.toString());
      throw Exception(e.toString());
    }
  }
}
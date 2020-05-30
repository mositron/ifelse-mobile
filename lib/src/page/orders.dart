import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../site.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/image.dart';
import 'order.dart';

class OrdersPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrdersPageScreenState();
  }
}

class OrdersPageScreenState extends State<OrdersPage> {
  bool loaded;
  List<dynamic> orders = [];
  RefreshController _refreshController = RefreshController(initialRefresh: false);

  @override
  void initState() {
    loaded = false;
    _loading();
    super.initState();
  }
  
  @override
  void dispose() {
    loaded = false;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      color: Color(0xffe0e0e0),
      home: Scaffold(
        backgroundColor: Color(0xffe0e0e0),
        appBar: AppBar(
          title: Text('ประวัติการสั่งซื้อสินค้า',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 22.0,
            ),      
            onPressed: () {
              Get.back();
            }
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: _getBody()
      )
    );
  }

  _loading() async {
    dynamic data = await Api.call('orders');
    loaded = true;
    if((data != null) && (data is Map)) {
      if((data['orders'] != null) && (data['orders'] is List)) {
        setState(() {
          orders = data['orders'].toList();
        });
      }
    }
  }

  _getBody() {
    if(loaded) {
      if(orders.length > 0) {
        return _smartView();
      } else {
        return Center(child: Text('- ยังไม่มีประวัติการสั่งซื้อ -', style: TextStyle(fontFamily: Site.font, fontSize: 14)));
      }
    }
    _loading();
    return Center(child: CircularProgressIndicator());
  }

  _smartView() {
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      header: MaterialClassicHeader(),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: orders.length,
        primary: false,
        shrinkWrap: true,
        padding: EdgeInsets.all(5),
        itemBuilder: (BuildContext context, int position) {
          final Map item = orders[position];
          return GestureDetector(
            onTap: () {
              Get.to(OrderPage(id: getInt(item['_id'])));
            },
            child: Card(
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Color(0xffcccccc)),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              elevation: 0,
              child: Container(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('คำสั่งซื้อ: #' + getString(item['no']), style: TextStyle(fontFamily: Site.font),maxLines: 1),
                              Text('สั่งซื้อวันที่: ' + getTime(item['added'],'datetime'), style: TextStyle(fontFamily: Site.font),maxLines: 1),
                            ]
                          ),
                        ),
                        Container(
                          child: Text(Site.orderStatus[getInt(item['status'])]['name'], style: TextStyle(fontFamily: Site.font),maxLines: 1),
                          
                        ),
                      ]
                    ),
                    SizedBox(width: 10),
                    _orderItem(context, item['product']),
                  ]
                ) 
              )
            )
          );
        }
      )
    );
  }
  
  _onRefresh() async{
    _loading();
    _refreshController.refreshCompleted();
  }
  
  void _onLoading() async{
    _loading();
    _refreshController.loadComplete();
  }

  _orderItem(BuildContext context, dynamic items) {
    if((items != null) && (items is List)) {
      return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Container(
              width: double.infinity,
              height: 0.5,
              margin: EdgeInsets.symmetric(vertical: 4),
              color: Colors.grey.shade400,
            ),
            SizedBox(height: 8),
            Container(
              child: ListView.builder(
                itemCount: (items.length > 3 ? 3 : items.length),
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final Map item = items[index];
                  return _orderListItem(item);
                },
              )
            ),
            items.length > 3 ? 
              Container(
                margin: EdgeInsets.only(top: 19),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                color: Color(0xfff0f0f0),
                child: Text('- คลิกเพื่อดูรายการอื่นๆ -', textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: 14)),
              ) :
              Container()
          ]
        ),
      );
    }
    return Container();
  }

  Widget _orderListItem(Map item) {
    if((item != null) && (item is Map)) {
      String title = item['title'];
      Map image = item['image'];
      int amount = item['amount'];
      double price = getDouble(item['price']);
      List<String> label = [];
      if((item['label'] != null) && (item['label'] is Map)) {
        item['label'].forEach((k,v){
          label.add(k + ': ' + v);
        });
      }
      List<Widget> lines = [];
      lines.add(
        Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize))
      );
      lines.add(
        SizedBox(height: 5)
      );
      if(label.length > 0) {
        lines.add(
          Text(label.join(' - '), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: 14))
        );
        lines.add(
          SizedBox(height: 5)
        );
      }
      lines.add(
        Container(
          child: Text(getCurrency(price) + ' x ' + amount.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontFamily: Site.font)),
        )
      );
        
      return Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 70,
                child: getImageRatio(image, 's', 0)
              ),
              SizedBox(width: 15),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: lines,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}

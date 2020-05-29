import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';
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

  @override
  void initState() {
    loaded = false;
    super.initState();
  }
  
  @override
  void dispose() {
    loaded = false;
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xffe0e0e0),
      child: FutureBuilder<Map<dynamic, dynamic>>(
        future: getPayment(),
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
            ? snapshot.hasData
              ? getWidget(snapshot.data)
              : retryButton(fetch)
            : IfDialog.getLoading();
        }
      )
    );
  }

  Future<Map<dynamic, dynamic>> getPayment() async {
    dynamic data = await Api.call('orders');
    return data;
  }

  setLoading(bool loading) {
    setState(() {
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }  

  FlatButton retryButton(Function fetch) {
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

  Widget getWidget(Map<dynamic, dynamic> data) {
    if((data != null) && (data is Map)) {
      if((data['orders'] != null) && (data['orders'] is List)) {
        orders = data['orders'].toList();
      }
    }
    return MaterialApp(      
      home: Scaffold(
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
        body: Container(
          color: Color(0xffe0e0e0),
          child: Column(  
            children: <Widget>[
              Expanded(
                child: Container(
                  //alignment: Alignment.centerLeft,
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
                                _orderItem(item['product']),
                              ]
                            ) 
                          )
                        )
                      );
                    }
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }



  _orderItem(dynamic items) {
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
                itemCount: items.length,
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  final Map item = items[index];
                  return _orderListItem(item);
                },
              )
            )
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

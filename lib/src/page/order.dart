import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/image.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';
import '../convert/bank.dart';
import '../page/inform.dart';

class OrderPage extends StatefulWidget {
  final int id;
  OrderPage({Key key, this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return OrderPageScreenState(id);
  }
}

class OrderPageScreenState extends State<OrderPage> {
  int id;
  bool loaded;
  Map order;
  int status = 0;
  List<dynamic> bank;
  OrderPageScreenState(this.id);

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
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Color(0xffe0e0e0),
      builder: (context, child) {
        return FutureBuilder<Map<dynamic, dynamic>>(
          future: getOder(),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                ? getWidget(snapshot.data)
                : retryButton(fetch)
              : IfDialog.getLoading();
          }
        );
      }
    );
  }

  Future<Map<dynamic, dynamic>> getOder() async {
    dynamic data = await Api.call('order',{'id': id.toString()});
    if((data != null) && (data is Map)) {
      if((data['order'] != null) && (data['order'] is Map)) {
        order = data['order'];
        status = getInt(order['status']);
        bank = order['bank'];
      }
    }
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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('รายละเอียดการสั่งซื้อ',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
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
                  alignment: Alignment.topCenter,
                  child: ListView(
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top:20, bottom:20, left: 5, right: 5),
                    children: <Widget>[
                      _orderProduct(),
                      _orderStatusButton(),
                      _orderPrice(),
                      _orderPayment(),
                      _orderItem(),
                    ],
                  ),
                ),
              ),
            ],
          )
        )
      )
    );
  }

  _orderProduct() {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xffcccccc)),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      margin: EdgeInsets.only(bottom:15,left:5,right:5),
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
                      Text('คำสั่งซื้อ: #' + getString(order['no']), style: TextStyle(fontFamily: Site.font),maxLines: 1),
                      Text('สั่งซื้อวันที่: ' + getTime(order['added'],'datetime'), style: TextStyle(fontFamily: Site.font),maxLines: 1),
                    ]
                  ),
                ),
                Container(
                  child: Text(Site.orderStatus[status]['name'], style: TextStyle(fontFamily: Site.font),maxLines: 1),
                  
                ),
              ]
            )
          ]
        ) 
      )
    );
  }

  _orderStatusButton() {
    if(status == 0) {
      return Container(
        margin: EdgeInsets.only(top:5, bottom:15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            _getButton('แจ้งการชำระเงิน', getColor('#28a745'), () {
              print(bank);
              _nextPage();
            }),
            SizedBox(width: 20),
            _getButton('ยกเลิกคำสั่งซื้อ', getColor('#999'), () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('ยืนยันการยกเลิก'),
                    content: const Text('ยกเลิกคำสั่งซื้อ, ต้องการดำเนินการต่อหรือไม่?'),
                    actions: <Widget>[
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                          _orderCancel();
                        },
                        child: Text('ยืนยัน', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Colors.white)),
                        color: Color(0xffff5717),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context, rootNavigator: true).pop('dialog');
                        },
                        child: Text('ยกเลิก', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Color(0xffff5717))),
                      ),
                    ],
                  );
                },
              );
            })
          ],
        )
      );
    }
    return Container();
  }

  _nextPage() async {
    dynamic result = await Get.to(InformPage(order: id, bank: bank));
    if((result is String) && (result == 'success')) {
      setLoading(true);
    }
  }
  _getButton(String text, Color color, Function func) {
    Color cartColor = getColor('fff');
    double cartFSize = 16;
    DecorationImage cartBg;
    Border cartBorder;
    BorderRadius cartRadius = BorderRadius.all(Radius.circular(5));
    List<BoxShadow> cartShadow;
    EdgeInsetsGeometry cartSpace = EdgeInsets.only(left:30,right:30,top:7,bottom:7);
    Text _text = Text(text, style: TextStyle(color:cartColor,fontFamily: Site.font, fontSize: cartFSize));    
    return Align(
      alignment: Alignment.center,
      child: Container(
        //width: double.infinity,
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        //alignment: getAlignBox(align),
        decoration: BoxDecoration(
          borderRadius: cartRadius,
          boxShadow: cartShadow,
        ),
        child: RawMaterialButton(
          onPressed: () {
            func();
          },
          padding: EdgeInsets.all(0.0),
          elevation: 0.0,
          child: Ink(            
            decoration: BoxDecoration(
              color: color,
              borderRadius: cartRadius,
              border: cartBorder,
              image: cartBg,
            ),
            padding: cartSpace,
            child: _text
          )
        )
      )
    );
  }

  _orderCancel() async {
    dynamic data = await Api.call('order',{'type':'cancel','id': id.toString()});
    if((data != null) && (data is Map)) {
      if((data['order'] != null) && (data['order'] is Map)) {
        setState(() {
          order = data['order'];
          status = getInt(order['status']);          
        });
      }
    }
  }


  _orderItem() {
    dynamic items = order['product'];
    if((items != null) && (items is List)) {
      return Card(
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
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('รายการสินค้า', style: TextStyle(fontFamily: Site.font),maxLines: 1),
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
                )
              )
            ]
          )
        )
      );
    }
    return Container();
  }

  _orderListItem(Map item) {
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
          Text(getString(label.join(' - ')), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: 14))
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


  _orderPayment() {
    if((order['pay'] != null) && (order['pay'] == 'bank') && (order['bank'] is List)) {
      return _orderPaymentBank(order['bank']);
    }
    return Container();
  }
  
  Widget _orderPaymentBank(dynamic data) {
    if(status == 0) {
      if((data != null) && (data is List) && (data.length > 0)) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.grey.shade200),
            color: Colors.white
          ),
          margin: EdgeInsets.only(left:5, right:5, bottom:15),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text('การชำระเงิน', style: TextStyle(fontFamily: Site.font)),
              SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  primary: false,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (BuildContext context, int position) {
                    final Map item = data[position];
                    return Container(
                      padding: EdgeInsets.only(top:10, bottom:10, left:5, right:15),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            child: Bank.getWidget(item['bank']),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(getString(item['name']), style: TextStyle(fontFamily: Site.font),maxLines: 1),
                                Text(Bank.getName(item['bank']) + ': ' + getString(item['number']), style: TextStyle(fontFamily: Site.font),maxLines: 2),
                              ]
                            )
                          )
                        ]
                      )              
                    );
                  }
                )
              )
            ]
          ),
        );
      }
    }
    return Container();
  }

  _orderPrice() {
    double ship = getDouble(order['ship']);
    double price = getDouble(order['price']);
    double total = getDouble(order['total']);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white
      ),
      margin: EdgeInsets.only(left:5, right:5, bottom:15),
      padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text('สรุปคำสั่งซื้อ', style: TextStyle(fontFamily: Site.font)),
          SizedBox(height: 4),
          Container(
            width: double.infinity,
            height: 0.5,
            margin: EdgeInsets.symmetric(vertical: 4),
            color: Colors.grey.shade400,
          ),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ยอดรวมสินค้า', style: TextStyle(fontFamily: Site.font)),
                Text(getCurrency(price), style: TextStyle(fontFamily: Site.font))
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('ค่าขนส่ง', style: TextStyle(fontFamily: Site.font)),
                Text(ship > 0 ? getCurrency(ship) : 'ฟรี', style: TextStyle(fontFamily: Site.font),
                )
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('ยอดรวมที่ต้องชำระ', style: TextStyle(fontFamily: Site.font)),
                Text(getCurrency(total), style: TextStyle(fontFamily: Site.font, fontSize: 20, color: Color(0xffff5717))),
              ],
            ),
          )
        ]
      )
    );
  }
}

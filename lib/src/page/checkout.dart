import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/image.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../my.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutPageScreenState();
  }
}


class CheckoutPageScreenState extends State<CheckoutPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  bool loaded;
  List<dynamic> address;
  int addressSelected = 0;
  List<dynamic> shipping;
  int shippingSelected = 0;

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
        color: Color(0xfff0f0f0),
        child: FutureBuilder<Map<dynamic, dynamic>>(
          future: getCheckout(),
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

  Future<Map<dynamic, dynamic>> getCheckout() async {
    return await Api.call('checkout');
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
      if((data['address'] != null) && (data['address'] is List)) {
        address = data['address'].toList();
      }
    }
    if((data != null) && (data is Map)) {
      if((data['shipping'] != null) && (data['shipping'] is List)) {
        shipping = data['shipping'].toList();
      }
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('ตรวจสอบคำสั่งซื้อ',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
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
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body:Builder(builder: (context) {
          return Column(
            
            children: <Widget>[
              Expanded(
                child: Container(
                  color: Colors.white,
                  child: ListView(
                    children: <Widget>[
                      selectedAddressSection(),
                      standardDelivery(),
                      checkoutItem(),
                      priceSection()
                    ],
                  ),
                ),
                flex: 90,
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: RaisedButton(
                    onPressed: () {
                      /*Navigator.of(context).push(new MaterialPageRoute(
                          builder: (context) => OrderPlacePage()));*/
                      showThankYouBottomSheet(context);
                    },
                    child: Text(
                      'ยืนยันคำสั่งซื้อ',
                      style: TextStyle(fontFamily: Site.font),
                    ),
                    color: Colors.pink,
                    textColor: Colors.white,
                  ),
                ),
                flex: 10,
              )
            ],
          );
        })
      )
    );
  }

  showThankYouBottomSheet(BuildContext context) {
    return _scaffoldKey.currentState.showBottomSheet((context) {
      return Container(
        height: 400,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200, width: 2),
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image(
                    image: AssetImage("images/ic_thank_you.png"),
                    width: 300,
                  ),
                ),
              ),
              flex: 5,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 16, right: 16),
                child: Column(
                  children: <Widget>[
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(children: [
                        TextSpan(
                          text:
                              "\n\nThank you for your purchase. Our company values each and every customer. We strive to provide state-of-the-art devices that respond to our clients’ individual needs. If you have any questions or feedback, please don’t hesitate to reach out.",
                          style: TextStyle(fontFamily: Site.font),
                        )
                      ]
                      )
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    RaisedButton(
                      onPressed: () {},
                      padding: EdgeInsets.only(left: 48, right: 48),
                      child: Text(
                        "Track Order",
                        style: TextStyle(fontFamily: Site.font)
                      ),
                      color: Colors.pink,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    )
                  ],
                ),
              ),
              flex: 5,
            )
          ],
        ),
      );
    },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16), topRight: Radius.circular(16))),
        backgroundColor: Colors.white,
        elevation: 2);
  }

  Widget selectedAddressSection() {
    if((address != null) && (address is List) && (address.length > addressSelected) && (address[addressSelected] is Map)) {
      Map item = address[addressSelected];
      return Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        child: Card(
          elevation: 0,
          color: Color(0xffe9e9e9),
          child: Container(
            padding: EdgeInsets.only(left: 12, top: 8, right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 6),
                Text(getString(item['name']), style: TextStyle(fontFamily: Site.font)),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'เบอร์โทรศัพท์: ', style: TextStyle(fontFamily: Site.font, color: Colors.black45)),
                      TextSpan(text: getString(item['phone']), style: TextStyle(fontFamily: Site.font, color: Colors.black)),
                    ]
                  ),
                ),
                SizedBox(height: 10),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(text: 'ที่อยู่: ', style: TextStyle(fontFamily: Site.font, color: Colors.black45)),
                      TextSpan(text: getString(item['address']) + ' - ' +getString(item['address']), style: TextStyle(fontFamily: Site.font, color: Colors.black)),
                    ]
                  ),
                ),
                Container(
                  color: Colors.white,
                  height: 1,
                  margin: EdgeInsets.only(top:10, bottom:10),
                  width: double.infinity,
                ),
                addressAction()
              ],
            ),
          ),
        ),
      );
    }
    return Container(
      child: Text('- ยังไม่มีที่อยู่ในการส่ง -')
    );
  }

  createAddressText(String strAddress, double topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin),
      child: Text(
        strAddress,
        style: TextStyle(fontFamily: Site.font)
      ),
    );
  }

  addressAction() {
    return Container(
      child: Row(
        children: <Widget>[
          Spacer(
            flex: 2,
          ),
          FlatButton(
            onPressed: () {},
            child: Text(
              "Edit / Change",
              style: TextStyle(fontFamily: Site.font)
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 3,
          ),
          Container(
            height: 20,
            width: 1,
            color: Colors.grey,
          ),
          Spacer(
            flex: 3,
          ),
          FlatButton(
            onPressed: () {},
            child: Text("Add New Address",
              style: TextStyle(fontFamily: Site.font)
            ),
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          Spacer(
            flex: 2,
          ),
        ],
      ),
    );
  }

  standardDelivery() {
    if((shipping != null) && (shipping is List) && (shipping.length > shippingSelected) && (shipping[shippingSelected] is Map)) {
      Map item = shipping[shippingSelected];
      return Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border:
                Border.all(color: Colors.tealAccent.withOpacity(0.4), width: 1),
            color: Colors.tealAccent.withOpacity(0.2)),
        margin: EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Radio(
              value: 1,
              groupValue: 1,
              onChanged: (isChecked) {},
              activeColor: Colors.tealAccent.shade400,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  getString(item['name']) + ' ('+getString(item['type'])+')',
                  style: TextStyle(fontFamily: Site.font),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(item['time'], style: TextStyle(fontFamily: Site.font))
              ],
            ),
          ],
        ),
      );
    }
    return Container(
      child: Text('- ยังไม่มีวิธีการส่ง (กรุณาติดต่อเจ้าของเว็บไซต์) -')
    );
  }

  checkoutItem() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: ListView.builder(
            itemCount: Cart.products.length,
            shrinkWrap: true,
            primary: false,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if((Cart.products.length > index)) {
                final Map item = Cart.products[index];
                return checkoutListItem(item);
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget checkoutListItem(Map item) {
    if((item != null) && (item is Map)) {
      int id = item['id'];
      int index = item['index'];
      String title = item['title'];
      Map image = item['image'];
      int amount = item['amount'];
      int stock = item['stock'];
      double price = item['price'];
      String name1 = item['name1'];
      String label1 = item['label1'];
      String name2 = item['name2'];
      String label2 = item['label2'];      
      List<String> label = [];
      if(name1.isNotEmpty && label1.isNotEmpty) {
        label.add(name1 + ': ' + label1);
      }
      if(name2.isNotEmpty && label2.isNotEmpty) {
        label.add(name2 + ': ' + label2);
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
                width: 90,
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

  priceSection() {
    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4))),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
              border: Border.all(color: Colors.grey.shade200)),
          padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 4,
              ),
              Text(
                "PRICE DETAILS",
                style: TextStyle(fontFamily: Site.font),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              createPriceItem("Total MRP", getCurrency(5197),
                  Colors.grey.shade700),
              createPriceItem("Bag discount", getCurrency(3280),
                  Colors.teal.shade300),
              createPriceItem(
                  "Tax", getCurrency(96), Colors.grey.shade700),
              createPriceItem("Order Total", getCurrency(2013),
                  Colors.grey.shade700),
              createPriceItem(
                  "Delievery Charges", "FREE", Colors.teal.shade300),
              SizedBox(
                height: 8,
              ),
              Container(
                width: double.infinity,
                height: 0.5,
                margin: EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(fontFamily: Site.font),
                  ),
                  Text(
                    getCurrency(2013),
                    style: TextStyle(fontFamily: Site.font),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  createPriceItem(String key, String value, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            key,
            style: TextStyle(fontFamily: Site.font),
          ),
          Text(
            value,
            style: TextStyle(fontFamily: Site.font),
          )
        ],
      ),
    );
  }
}

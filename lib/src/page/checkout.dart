import 'package:flutter/material.dart';
import 'package:ifelse/src/convert/image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';
import '../bloc/checkout.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutPageScreenState();
  }
}


class CheckoutPageScreenState extends State<CheckoutPage> {
  bool loaded;
  List<dynamic> address;
  int addressSelected = 0;
  List<dynamic> shipping;
  int shippingSelected = -1;
  CheckoutBloc checkoutBloc;

  @override
  void initState() {
    loaded = false;
    super.initState();
  }
  
  @override
  void dispose() {
    loaded = false;
    checkoutBloc.drain();
    checkoutBloc.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    checkoutBloc = CheckoutBloc();
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
          title: Text('การจัดส่ง',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
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
          color: Color(0xfff0f0f0),
          child: Builder(builder: (context) {
            return BlocProvider<CheckoutBloc>(
              create: (context) => checkoutBloc,
              child: Column(  
                children: <Widget>[
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        padding: EdgeInsets.all(0),
                        children: <Widget>[
                          selectedAddressSection(),
                          standardDelivery(),
                          priceSection(),
                          checkoutItem(),
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
                              
                        },
                        child: Text(
                          'ชำระเงิน',
                          style: TextStyle(fontFamily: Site.font),
                        ),
                        color: Colors.pink,
                        textColor: Colors.white,
                      ),
                    ),
                    flex: 10,
                  )
                ],
              )
            );
          })
        )
      )
    );
  }

  Widget selectedAddressSection() {
    if((address != null) && (address is List)) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อและที่อยู่ในการจัดส่ง', style: TextStyle(fontFamily: Site.font)),
                GestureDetector(
                  onTap: () {

                  },
                  child: Text('เพิ่มที่อยู่ใหม่', style: TextStyle(fontFamily: Site.font)),
                ),
                /*
                FlatButton(
                  padding: EdgeInsets.all(0),
                  onPressed: () {},
                  child: Text('เพิ่มที่อยู่ใหม่',style: TextStyle(fontFamily: Site.font)),
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                */
              ],
            ),
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
                itemCount: address.length,
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int position) {
                  final Map item = address[position];
                  _click() {
                    addressSelected = position;
                  }
                  return InkWell(
                    onTap: () {
                      _click();
                    },
                    child: BlocBuilder<CheckoutBloc, int>(
                      bloc: checkoutBloc,
                      builder: (_, product) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color((addressSelected == position) ? 0xffff5717 : 0xffcccccc)),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          elevation: 0,
                          margin: EdgeInsets.only(top: 10),
                          child: Container(
                            padding: EdgeInsets.only(top:10, bottom:10, left:5, right:15),
                            child: Row(
                              children: [
                                Radio(
                                  value: position,
                                  groupValue: addressSelected,
                                  activeColor: Color(0xffff5717),
                                  onChanged: (int value) {
                                    //addressSelected = value;
                                    _click();
                                  },
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(getString(item['name']) + ' ('+getString(item['phone'])+')', style: TextStyle(fontFamily: Site.font),maxLines: 1),
                                      SizedBox(height: 5),
                                      Text(getString(item['address']), style: TextStyle(fontFamily: Site.font),maxLines: 2),
                                    ]
                                  )
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    ),
                  );
                }
              )
            )
          ]
        ),
      );
    }
    return Container(
      child: Text('- ยังไม่มีที่อยู่ในการส่ง -')
    );
  }

  standardDelivery() {
    if((shipping != null) && (shipping is List)) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 10),
        child: BlocBuilder<CheckoutBloc, int>(
          bloc: checkoutBloc,
          builder: (_, product) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Text('วิธีการจัดส่ง', style: TextStyle(fontFamily: Site.font)),
                SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  color: Colors.grey.shade400,
                ),
                Container(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: shipping.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int position) {
                      final Map item = shipping[position];
                      final double shipPrice = calcShipping(item);
                      _click() {
                          Cart.shipId = getInt(item['id']);
                          Cart.shipPrice = shipPrice;
                          shippingSelected = position;
                          checkoutBloc.add('selected');
                      }
                      return InkWell(
                        onTap: () {
                          _click();
                        },
                        child: BlocBuilder<CheckoutBloc, int>(
                          bloc: checkoutBloc,
                          builder: (_, product) {
                            String time = getString(item['time']);
                            return Card(
                              shape: RoundedRectangleBorder(
                                side: BorderSide(color: Color((shippingSelected == position) ? 0xffff5717 : 0xffcccccc)),
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.only(top: 10),
                              child: Container(
                                padding: EdgeInsets.only(top:10, bottom:10, left:5, right:15),
                                child: Row(
                                  children: [
                                    Radio(
                                      value: position,
                                      groupValue: shippingSelected,
                                      activeColor: Color(0xffff5717),
                                      onChanged: (int value) {
                                        //shippingSelected = value;
                                        _click();
                                      },
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getString(item['name']) + ' ('+getString(item['type'])+')',
                                            style: TextStyle(fontFamily: Site.font),
                                          ),
                                          SizedBox(height: 5),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(time + (time.isNotEmpty?' วัน':''), style: TextStyle(fontFamily: Site.font)),
                                              (
                                                shipPrice > 0 ?
                                                Text('+' + getCurrency(shipPrice), style: TextStyle(fontFamily: Site.font, color: Color(0xffff5717)), textAlign: TextAlign.right) : 
                                                Text('ฟรี', style: TextStyle(fontFamily: Site.font, color: Colors.green), textAlign: TextAlign.right)
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      );
                    }
                  )
                )
              ],
            );
          }
        )
      );
    }
    return Container(
      child: Text('- ยังไม่มีวิธีการส่ง (กรุณาติดต่อเจ้าของเว็บไซต์) -')
    );
  }

  double calcShipping(Map item) {
    int rate = getInt(item['rate']);
    double found = -1;
    if(rate == 3) {
      dynamic range = item['range'];
      if((range != null) && (range is Map)) {
        for (var key in range.keys) {
          double price = getDouble(key);
          if(price < Cart.price) {
            found = getDouble(range[key]);
          }
        }
      }
    } else if(rate == 4) {
      dynamic range = item['range'];
      if((range != null) && (range is Map)) {
        for (var key in range.keys) {
          double weight = getDouble(key);
          if(weight < Cart.weight) {
            found = getDouble(range[key]);
          }
        }
      }
    } else if(rate == 5) {
      dynamic range = item['range'];
      if((range != null) && (range is Map)) {
        for (var key in range.keys) {
          double amount = getDouble(key);
          if(amount < Cart.amount) {
            found = getDouble(range[key]);
          }
        }
      }
    } else if(rate == 6) {
      found = getDouble(item['range']) + ((Cart.amount - 1) * getDouble(item['price']));
    }
    if(found == -1) {
      found = getDouble(item['price']);
    }
    return found;
  }

  checkoutItem() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 4),
          Text('รายละเอียดสินค้า', style: TextStyle(fontFamily: Site.font)),
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
            )
          )
        ]
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey.shade200),
        color: Colors.white
      ),
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 8),
      child: BlocBuilder<CheckoutBloc, int>(
        bloc: checkoutBloc,
        builder: (_, product) {
          return Column(
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
                    Text(getCurrency(Cart.price), style: TextStyle(fontFamily: Site.font))
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('ค่าขนส่ง', style: TextStyle(fontFamily: Site.font)),
                    Text(Cart.shipPrice > 0 ? getCurrency(Cart.shipPrice) : 'ฟรี', style: TextStyle(fontFamily: Site.font),
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
                    Text(getCurrency(Cart.price + Cart.shipPrice), style: TextStyle(fontFamily: Site.font),
                    )
                  ],
                ),
              )
            ]
          );
        }
      ),
    );
  }
}

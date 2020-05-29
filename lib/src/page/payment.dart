import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';
import '../convert/bank.dart';
import '../convert/image.dart';
import '../convert/toast.dart';
import '../bloc/payment.dart';
import 'home.dart';

class PaymentPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PaymentPageScreenState();
  }
}

class PaymentPageScreenState extends State<PaymentPage> {
  bool loaded;
  PaymentBloc paymentBloc;
  int paymentSelected = -1;

  @override
  void initState() {
    loaded = false;
    super.initState();
  }
  
  @override
  void dispose() {
    loaded = false;
    paymentBloc.drain();
    paymentBloc.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    paymentBloc = PaymentBloc();
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
    dynamic data = await Api.call('payment');    
    if((data != null) && (data is Map)) {
      if((data['payment'] != null) && (data['payment'] is Map)) {
        Cart.payment = data['payment'];
      }
    }
    print(data);
    _alertNoPayment();
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
      home: BlocProvider<PaymentBloc>(
        create: (context) => paymentBloc,
        child: Scaffold(
          appBar: AppBar(
            title: Text('การชำระเงิน',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
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
                    alignment: Alignment.centerLeft,
                    child: ListView(
                      primary: false,
                      shrinkWrap: true,
                      padding: EdgeInsets.all(0),
                      children: <Widget>[
                        paymentSection(),
                        priceSection(),
                        shippingSection(),
                        checkoutItem(),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
          bottomNavigationBar: Container(
            //height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            margin: EdgeInsets.all(0),
            padding: EdgeInsets.only(left:10, right:10),
            child: Container(
              child:Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 70,
                    child:Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //Text('ยอดรวมต้องชำระ', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)),
                      ],
                    )
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 70,
                    child: _getButton('btn'),
                  )
                ],
              )
            )
          )
        )
      )
    );
  }

  _alertNoPayment() async {
    if((Cart.payment == null) ||  (Cart.payment is! Map) ||  (Cart.payment.length == 0)) {
      print('no');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ไม่มีวิธีการชำระเงิน'),
          content: const Text('กรุณาติดต่อเจ้าของเว็บไซต์'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
              },
              child: Text('ปิด', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Color(0xffff5717))),
            ),
          ],
        )
      );
    }
  }

  Widget _getButton(String type) {
    String cartText = 'ยืนยันคำสั่งซื้อ';
    Color cartColor = getColor('fff');
    double cartFSize = 16;
    IconData cartIcon;
    String cartIpos = 'left';
    DecorationImage cartBg;
    Border cartBorder;
    BorderRadius cartRadius = BorderRadius.all(Radius.circular(5));
    List<BoxShadow> cartShadow;
    EdgeInsetsGeometry cartSpace = EdgeInsets.only(left:30,right:30,top:7,bottom:7);

    List<Widget> widget = [];
    Icon _icon = Icon(cartIcon, color: cartColor, size: cartFSize,);
    Text _text = Text(cartText, style: TextStyle(color:cartColor,fontFamily: Site.font, fontSize: cartFSize));
    
    if(cartText.isNotEmpty && cartIcon != null) {
      if(cartIpos == 'right') {
        widget = [_text, SizedBox(width: 8), _icon,];
      } else if(cartIpos == 'up') {
        widget = [_icon, SizedBox(height: 3), _text,];
      } else {
        widget = [_icon, SizedBox(width: 8), _text,];
      }
    } else if(cartText.isNotEmpty) {
      widget = [_text];
    } else if(cartIcon != null) {
      widget = [_icon];
    }
    return Align(
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.all(0),
        padding: EdgeInsets.all(0),
        //alignment: getAlignBox(align),
        decoration: BoxDecoration(
          borderRadius: cartRadius,
          boxShadow: cartShadow,
        ),
        child: RawMaterialButton(
          onPressed: () {
            _paymentConfirm();
          },
          padding: EdgeInsets.all(0.0),
          elevation: 0.0,
          child: Ink(            
            decoration: BoxDecoration(
              color: Color(0xffff5717),
              borderRadius: cartRadius,
              border: cartBorder,
              image: cartBg,
            ),
            padding: cartSpace,
            child: cartIpos == 'up' ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center ,
                mainAxisSize: MainAxisSize.min,
                children: widget,
              )
              :
              Row(
                mainAxisAlignment: MainAxisAlignment.center ,
                mainAxisSize: MainAxisSize.min,
                children: widget,
            )
          )
        )
      )
    );
  }

  Widget paymentSection() {
    if((Cart.payment != null) && (Cart.payment is Map) && (Cart.payment.length > 0)) {
      List<Widget> _widget = [];
      print('object');
      for(var k in Cart.payment.keys) {
        if(k == 'bank') {
          _widget.add(paymentBank(Cart.payment[k]));
        }
      }
      if(_widget.length > 0) {
        return Column(
          children: _widget
        );
      }
    }
    return Container();
  }

  Widget paymentBank(dynamic data) {
    if((data != null) && (data is List) && (data.length > 0)) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.grey.shade200),
          color: Colors.white
        ),
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text('โอนเงินผ่านธนาคาร', style: TextStyle(fontFamily: Site.font)),
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
                  return InkWell(
                    onTap: () {
                      Cart.payType = 'bank';
                      Cart.payBank = getInt(item['_id']);
                      _paymentSelect(position);
                    },
                    child: BlocBuilder<PaymentBloc, int>(
                      bloc: paymentBloc,
                      builder: (_, product) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color((paymentSelected == position) ? 0xffff5717 : 0xffcccccc)),
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
                                  groupValue: paymentSelected,
                                  activeColor: Color(0xffff5717),
                                  onChanged: (int value) {
                                    _paymentSelect(position);
                                  },
                                ),
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
                          )
                        );
                      }
                    )                  
                  );
                }
              )
            )
          ]
        ),
      );
    }
    return Container(
      child: Text('- ยังไม่มีวิธีการชำระเงิน -')
    );
  }
  
  _paymentSelect(int index) {
    paymentSelected = index;
    paymentBloc.add('selected');
  }

  _paymentConfirm() async {
    if((paymentSelected == -1) || (Cart.payBank  == 0)) {
      Toast.show('กรุณาเลือกวิธีการชำระเงิน', context, duration: Toast.lengthShort, gravity:  Toast.bottom);
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ยันยันคำสั่งซื้อ'),
          content: const Text('หากยืนยันแล้วจะไม่สามารถแก้ไขข้อมูลได้อีก, ต้องการดำเนินการต่อหรือไม่?'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _sendCart();
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
  }

  _sendCart() async {    
    IfDialog().loading(context);
    List<dynamic> products = [];
    List<dynamic> error = [];
    Cart.products.forEach((v) {
      int id = getInt(v['id']);
      int amount = getInt(v['amount']);
      int index = getInt(v['index']);
      double price = getDouble(v['price']);
      if((id > 0) && (amount > 0)) {
        products.add({'_id':id, 'index': index, 'amount': amount, 'price': price});
      } else {
        products.add({'_id':id, 'title': getString(v['title']), 'amount': amount});
      }
    });
    if(error.length > 0) {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Toast.show('สินค้าบางรายการ มีข้อมูลไม่ถูกต้อง', context, duration: Toast.lengthShort, gravity:  Toast.bottom);
    } else if(products.length == 0) {
      Navigator.of(context, rootNavigator: true).pop('dialog');      
      Toast.show('ไม่มีสินค้าในตะกร้า', context, duration: Toast.lengthShort, gravity:  Toast.bottom);
    } else {
      dynamic response = await Api.call('cart', {
        'type': 'new',
        'product': json.encode(products),
        'amount': Cart.amount.toString(),
        'price': Cart.price.toString(),
        'weight': Cart.weight.toString(),
        'ship_id': Cart.shipId.toString(),
        'ship_price': Cart.shipPrice.toString(),
        'ship_name': Cart.shipName,
        'ship_phone': Cart.shipPhone,
        'ship_address': Cart.shipAddress,
        'pay_bank': Cart.payBank.toString(),
        'pay_type': Cart.payType,
      });
      print(response);
      Navigator.of(context, rootNavigator: true).pop('dialog');
      if((response != null) && (response is Map)) {
        if((response['error'] != null) && (response['error'] is List)) {
          List<Widget> _error = [];
          response['error'].forEach((v) {
            _error.add(Text(getString(v), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)));
          });
          print(response['error']);
          if(_error.length > 0) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('เกิดข้อผิดพลาด'),
                content: Column(children: _error),
                actions: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop('dialog');
                    },
                    child: Text('ปิด', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Color(0xffff5717))),
                  ),
                ],
              )
            );
          }
        } else if((response['order'] != null) && (response['order'].toString().isNotEmpty)) {
          Get.offAll(HomePage(next: 'order', par: {'id': getInt(response['order'])}));
        }
      }
    }
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
      )
    );
  }

  shippingSection() {
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
          Text('การส่งสินค้า', style: TextStyle(fontFamily: Site.font)),
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
                Text('จัดส่งโดย', style: TextStyle(fontFamily: Site.font)),
                SizedBox(width: 10),
                Expanded(child: Text(Cart.shipDetail, textAlign: TextAlign.right, style: TextStyle(fontFamily: Site.font))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('ชื่อผู้รับ', style: TextStyle(fontFamily: Site.font)),
                SizedBox(width: 10),
                Expanded(child: Text(Cart.shipName, textAlign: TextAlign.right, style: TextStyle(fontFamily: Site.font))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('เบอร์โทรศัพท์', style: TextStyle(fontFamily: Site.font)),
                SizedBox(width: 10),
                Expanded(child: Text(Cart.shipPhone, textAlign: TextAlign.right, style: TextStyle(fontFamily: Site.font))),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('ที่อยู่', style: TextStyle(fontFamily: Site.font)),
                SizedBox(width: 10),
                Expanded(child: Text(Cart.shipAddress, textAlign: TextAlign.right, style: TextStyle(fontFamily: Site.font))),
              ],
            ),
          ),
        ]
      )
    );
  }
}

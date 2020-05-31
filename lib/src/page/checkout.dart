import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';
import '../convert/image.dart';
import '../convert/toast.dart';
import '../bloc/checkout.dart';
import 'address.dart';
import 'payment.dart';

class CheckoutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CheckoutState();
  }
}

class CheckoutState extends State<CheckoutPage> {
  bool loaded;
  List<dynamic> address;
  int addressSelected = -1;
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
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Color(0xffe0e0e0),
      builder: (context, child) {
        return FutureBuilder<Map<dynamic, dynamic>>(
          future: getCheckout(),
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

  Future<Map<dynamic, dynamic>> getCheckout() async {
    dynamic data = await Api.call('checkout');    
    if((data != null) && (data is Map)) {
      if((data['address'] != null) && (data['address'] is List)) {
        Cart.address = data['address'].toList();
      }
    }
    if((data != null) && (data is Map)) {
      if((data['shipping'] != null) && (data['shipping'] is List)) {
        shipping = data['shipping'].toList();
      }
    }
    _alertNoAddress();
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
    return BlocProvider<CheckoutBloc>(
      create: (context) => checkoutBloc,
      child: Scaffold(
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
                      selectedAddressSection(),
                      standardDelivery(),
                      priceSection(),
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
                    Text('ยอดรวมต้องชำระ', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)),
                    BlocBuilder<CheckoutBloc, int>(
                      bloc: checkoutBloc,
                      builder: (_, count) {
                        if((addressSelected == -1) || (addressSelected >= Cart.address.length)) {
                          return Text('กรุณาเลือกที่อยู่ในการจัดส่ง', style: TextStyle(fontFamily: Site.font, color: Colors.redAccent, fontSize: 16));
                        } else if((shippingSelected == -1) || (shippingSelected >= shipping.length)) {
                          return Text('กรุณาเลือกวิธีการจัดส่ง', style: TextStyle(fontFamily: Site.font, color: Colors.redAccent, fontSize: 16));
                        } else {
                          return Text(getCurrency(Cart.price + Cart.shipPrice), style: TextStyle(fontFamily: Site.font, color: Color(0xffff5717), fontSize: 18));
                        }
                      }
                    )
                  ],
                )
              ),
              Container(
                alignment: Alignment.centerRight,
                height: 70,
                child: _getButton('btn'),
              )
            ],
          ))
        )
      )
    );
  }

  _alertNoAddress() async {
    if((Cart.address == null) ||  (Cart.address is! List) ||  (Cart.address.length == 0)) {
      print('no');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('ยังไม่มีที่อยู่'),
          content: const Text('ยังไม่มีข้อมูลสำหรับที่อยู่ในการจัดส่ง, กรุณาเพิ่มข้อมูล'),
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop('dialog');
                _addAddress(-1);
              },
              child: Text('เพิ่มที่อยู่', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Colors.white)),
              color: Color(0xffff5717),
            ),
          ],
        )
      );
    }
  }



  Widget _getButton(String type) {
    String cartText = 'ชำระเงิน';
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
            if((addressSelected == -1) || (addressSelected >= Cart.address.length)) {
              Toast.show('กรุณาเลือกที่อยู่ในการจัดส่ง', context, duration: Toast.lengthLong, gravity: Toast.bottom);
            } else if((shippingSelected == -1) || (shippingSelected >= shipping.length)) {
              Toast.show('กรุณาเลือกวิธีการจัดส่ง', context, duration: Toast.lengthLong, gravity: Toast.bottom);
            } else {
              Get.to(PaymentPage());
            }
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

  Widget selectedAddressSection() {
    if((Cart.address != null) && (Cart.address is List)) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ชื่อและที่อยู่ในการจัดส่ง', style: TextStyle(fontFamily: Site.font)),
                GestureDetector(
                  onTap: () {
                     _addAddress(-1);
                  },
                  child: Text('เพิ่มที่อยู่ใหม่', style: TextStyle(fontFamily: Site.font)),
                ),
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
              child: BlocBuilder<CheckoutBloc, int>(
                bloc: checkoutBloc,
                builder: (_, product) {
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: Cart.address.length,
                    primary: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int position) {
                      final Map item = Cart.address[position];
                      return Dismissible(
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          Cart.address.removeAt(position);
                          print(position);
                          _addressRemove(position);
                        },
                        confirmDismiss: (DismissDirection direction) async {
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('ยืนยันการลบที่อยู่'),
                                content: const Text('ต้องการลบที่อยู่ในการจัดส่งนี้หรือไม่?'),
                                actions: <Widget>[
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: Text('ลบ', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Colors.white)),
                                    color: Color(0xffff5717),
                                  ),
                                  FlatButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: Text('ยกเลิก', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Color(0xffff5717))),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: InkWell(
                          onTap: () {
                            _addressSelect(position);
                          },
                          child: Card(
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
                                      _addressSelect(position);
                                    },
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(getString(item['name']) + ' ('+getString(item['phone'])+')', style: TextStyle(fontFamily: Site.font),maxLines: 1),
                                        Text(getString(item['address']), style: TextStyle(fontFamily: Site.font),maxLines: 2),
                                      ]
                                    )
                                  )
                                ]
                              )
                            )
                          )
                        )
                      );
                    }
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

  _addAddress(int index) async {
    await Get.to(AddressPage(edit: index, next: 'back'));
    checkoutBloc.add('selected');
  }
  
  _addressSelect(int index) {
    addressSelected = index;
    if((Cart.address[index] != null) && (Cart.address[index] is Map)) {
      Cart.shipName = getString(Cart.address[index]['name']);
      Cart.shipPhone = getString(Cart.address[index]['phone']);
      Cart.shipAddress = getString(Cart.address[index]['address']);
    }
    checkoutBloc.add('selected');
  }

  _addressRemove(int index) async {
    IfDialog().loading(context);
    dynamic response = await Api.call('address', {
      'type': 'remove',
      'index': index.toString(),
    });
    print(response);
    if((response != null) && (response is Map)) {
      if((getString(response['status']) == 'OK') && (response['address'] is List)) {
        Cart.address = response['address'].toList();
      }
    }
    checkoutBloc.add('selected');
    Navigator.of(context, rootNavigator: true).pop('dialog');
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
        padding: EdgeInsets.only(left: 12, top: 8, right: 12, bottom: 12),
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
                        Cart.shipId = getInt(item['_id']);
                        Cart.shipPrice = shipPrice;
                        Cart.shipDetail = getString(item['name']) + ' ('+getString(item['type'])+')';
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
          if(Cart.price < price) {
            found = getDouble(range[key]);
            break;
          }
        }
      }
    } else if(rate == 4) {
      dynamic range = item['range'];
      if((range != null) && (range is Map)) {
        for (var key in range.keys) {
          double weight = getDouble(key);
          if(Cart.weight < weight) {
            found = getDouble(range[key]);
            break;
          }
        }
      }
    } else if(rate == 5) {
      dynamic range = item['range'];
      if((range != null) && (range is Map)) {
        for (var key in range.keys) {
          double amount = getDouble(key);
          if(Cart.amount < amount) {
            found = getDouble(range[key]);
            break;
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

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';

class AddressPage extends StatefulWidget {
  final int edit;
  final String next;
  AddressPage({Key key, this.edit, this.next}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return AddressPageScreenState(edit, next);
  }
}

class AddressPageScreenState extends State<AddressPage> {
  int edit = -1;
  String next;
  
  TextEditingController controllerName;
  TextEditingController controllerPhone;
  TextEditingController controllerAddress;

  AddressPageScreenState(this.edit, this.next);

  @override
  void initState() {
    super.initState();
    String initName = '';
    String initPhone = '';
    String initAddress = '';
    if((edit > -1) && (edit < Cart.address.length)) {
      dynamic item = Cart.address[edit];
      if((item != null) && (item is Map)) {
        initName = getString(Cart.address[edit]);
        initPhone = getString(Cart.address[edit]);
        initAddress = getString(Cart.address[edit]);
      } else {
        edit = -1;
      }
    }
    controllerName = TextEditingController(text: initName);
    controllerPhone = TextEditingController(text: initPhone);
    controllerAddress = TextEditingController(text: initAddress);
  }
  
  @override
  void dispose() {
    controllerName.dispose();
    controllerPhone.dispose();
    controllerAddress.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text((edit == -1 ? 'เพิ่ม' : 'แก้ไข') + 'ชื่อและที่อยู่ในการจัดส่ง',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
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
        backgroundColor: Color(0xffe0e0e0),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
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
                Text('ชื่อและที่อยู่ สำหรับการจัดส่งและรับสินค้า', style: TextStyle(fontFamily: Site.font)),
                SizedBox(height: 4),
                Container(
                  width: double.infinity,
                  height: 0.5,
                  margin: EdgeInsets.symmetric(vertical: 4),
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 8),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text('ขื่อ-นามสกุล', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: controllerName,
                        style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font),
                        decoration: InputDecoration(hintText: 'ชื่อ-นามสกุล สำหรับการรับสินค้า',),
                        //autofocus: true,
                      ),
                      SizedBox(height: 20),
                      Text('เบอร์โทรศัพท์', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: controllerPhone,
                        style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font),
                        decoration: InputDecoration(hintText: 'เบอร์โทรศัพท์ สำหรับการติดต่อเพื่อรับสินค้า'),
                      ),
                      SizedBox(height: 20),
                      Text('ที่อยู่ในการจัดส่ง', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: controllerAddress,
                        style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font),
                        decoration: InputDecoration(hintText: 'ที่อยู่ สำหรับการรับสินค้า'),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        //enabled: !_status,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(right: 10.0),
                              child: Container(
                                  child: RaisedButton(
                                child: Text(' บันทึก '),
                                textColor: Colors.white,
                                color: Color(0xffff5717),
                                onPressed: () {
                                  _saveAddress(context);
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              )),
                            ),
                            flex: 2,
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0),
                              child: Container(
                                  child: RaisedButton(
                                child: Text(' ยกเลิก '),
                                textColor: Colors.black,
                                color: Color(0xffcccccc),
                                onPressed: () {
                                  Get.back();
                                },
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                              )),
                            ),
                            flex: 2,
                          ),
                        ],
                      )
                    ],
                  )
                )
              ]
            )
          )
        )
      )
    );
  }

  
  void _saveAddress(BuildContext context) async {
    String name = controllerName.text.trim();
    String phone = controllerPhone.text.trim();
    String address = controllerAddress.text.trim();
    if(name.length < 3) {
      await IfDialog.show(context: context, text: 'ชื่อ-นามสกุล ไม่ถูกต้อง');
    } else if(phone.length < 10) {
      await IfDialog.show(context: context, text: 'เบอร์โทรศัพท์ ไม่ถูกต้อง');
    } else if(address.length < 20) {
      await IfDialog.show(context: context, text: 'ที่อยู่ ไม่ถูกต้อง');
    } else {
      try {
        IfDialog().loading(context);
        dynamic response = await Api.call('address', {
          'type': 'save',
          'index': edit.toString(),
          'name': name,
          'phone': phone,
          'address': address,
        });
        print(response);
        if((response != null) && (response is Map)) {
          if((getString(response['status']) == 'OK') && (response['address'] is List)) {
            Cart.address = response['address'].toList();
          }
        }
      } catch (e) {
        
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Get.back(result: 'success');
    }
  }
}

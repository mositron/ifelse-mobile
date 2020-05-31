import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../site.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';
import '../convert/bank.dart';
import '../convert/toast.dart';
import '../bloc/inform.dart';

class InformPage extends StatefulWidget {
  final int order;
  final List<dynamic> bank;
  InformPage({Key key, this.order, this.bank}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return InformState(order, bank);
  }
}

class InformState extends State<InformPage> {
  int order = 0;
  List<dynamic> bank;
  DateTime pickedDate;
  TimeOfDay time;
  TextEditingController controllerAmount;
  TextEditingController controllerNote;
  File _imageFile;
  String _imageName = '';
  int bankSelected = -1;
  int bankId = 0;
  InformBloc informBloc;
  InformState(this.order, this.bank);

  @override
  void initState() {
    super.initState();
    controllerAmount = TextEditingController(text: '');
    controllerNote = TextEditingController(text: '');
    pickedDate = DateTime.now();
    time = TimeOfDay.now();
  }
  
  @override
  void dispose() {
    controllerAmount.dispose();
    controllerNote.dispose();
    informBloc.drain();
    informBloc.close();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {    
    informBloc = InformBloc();
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Color(0xffe0e0e0),
      builder: (context, child) { 
        return Scaffold(
          appBar: AppBar(
            title: Text('แจ้งการชำระเงิน',style: TextStyle(fontFamily: Site.font, color: Color(0xff565758))),
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
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                _formBank(),
                _formDetail()
              ],
            )
          )
          ,bottomNavigationBar: Container(
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
                        Text('กรุณากรอกข้อมูลให้ครบถ้วน', overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)),
                      ],
                    )
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    height: 70,
                    child: _getButton(),
                  )
                ],
              )
            )
          )
        );
      }
    );
  }


  Widget _getButton() {
    String cartText = 'แจ้งการชำระเงิน';
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
            _sendInform();
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

  _sendInform() async {
    String amount = controllerAmount.text.trim();
    String tranfer = pickedDate.year.toString() + '-' + pickedDate.month.toString().padLeft(2, '0') + '-' + pickedDate.day.toString().padLeft(2, '0') + 
                  time.hour.toString().padLeft(2, '0') + ':' + time.minute.toString().padLeft(2, '0') + ':00';
    String slip = _imageFile != null ? base64Encode(_imageFile.readAsBytesSync()) : '';
    String note = controllerNote.text.trim();
    
    if(amount.length == 0) {
      Toast.show('กรุณากรอกจำนวนเงิน', context, duration: Toast.lengthLong, gravity:  Toast.bottom);
    } else if(bankId == 0) {   
      Toast.show('กรุณาเลือกธนาคารที่โอน', context, duration: Toast.lengthLong, gravity:  Toast.bottom);
    } else {
      IfDialog().loading(context);
      dynamic response = await Api.call('inform', {        
        'amount': amount,
        'tranfer': tranfer,
        'slip': slip,
        'note': note,
        'bank': bankId.toString(),
        'order': order.toString()
      });
      Navigator.of(context, rootNavigator: true).pop('dialog');
      print(response);
      if((response != null) && (response is Map)) {
        if((response['error'] != null) && (response['error'] is List)) {
          List<Widget> _error = [];
          response['error'].forEach((v) {
            _error.add(Text(getString(v), maxLines: 2, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize)));
          });
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
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('เรียบร้อย'),
              content: Text('แจ้งการชำระเงินเรียบร้อยแล้ว'),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop('dialog');
                    Get.back(result: 'success');
                  },
                  child: Text('ตกลง', style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize, color: Color(0xffff5717))),
                ),
              ],
            )
          );
        }
      }
    }
  }


  Widget _formBank() {
    if((bank != null) && (bank is List) && (bank.length > 0)) {
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
                itemCount: bank.length,
                primary: false,
                shrinkWrap: true,
                padding: EdgeInsets.all(0),
                itemBuilder: (BuildContext context, int position) {
                  final Map item = bank[position];
                  return InkWell(
                    onTap: () {
                      //Cart.payBank = getInt(item['_id']);
                      bankId = getInt(item['_id']);
                      _bankSelect(position);
                    },
                    child: BlocBuilder<InformBloc, int>(
                      bloc: informBloc,
                      builder: (_, product) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Color((bankSelected == position) ? 0xffff5717 : 0xffcccccc)),
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
                                  groupValue: bankSelected,
                                  activeColor: Color(0xffff5717),
                                  onChanged: (int value) {
                                    _bankSelect(position);
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

  _formDetail() {
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
          Text('ข้อมูลสำหรับการโอนเงิน', style: TextStyle(fontFamily: Site.font)),
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
                Text('จำนวนเงิน', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                TextField(
                  controller: controllerAmount,
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly
                  ],
                  style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font),
                  decoration: InputDecoration(hintText: 'จำนวนเงินที่โอน'),
                  //autofocus: true,
                ),
                SizedBox(height: 20),
                Text('วันที่โอน', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                _inputForm(pickedDate.year.toString() + '-' + pickedDate.month.toString().padLeft(2, '0') + '-' + pickedDate.day.toString().padLeft(2, '0'), _pickDate),
                SizedBox(height: 20),
                Text('เวลาที่โอน', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                _inputForm(time.hour.toString().padLeft(2, '0') + ':' + time.minute.toString().padLeft(2, '0'), _pickTime),
                SizedBox(height: 20),
                Text('หลักฐานการโอน / สลิป', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                _inputForm(_imageName, _pickImage),
                SizedBox(height: 20),
                Text('หมายเหตุ', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                TextField(
                  controller: controllerNote,
                  style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font),
                  decoration: InputDecoration(hintText: 'ปล่อยว่างได้'),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  //enabled: !_status,
                ),
              ],
            )
          )
        ]
      )
    );
  }

  _inputForm(String valueText, Function onPressed) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          contentPadding: EdgeInsets.all(0)
        ),
        
        baseStyle: TextStyle(fontFamily: Site.font, fontSize: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Text(valueText, overflow: TextOverflow.ellipsis, style: TextStyle(fontFamily: Site.font, fontSize: 16)),
            ),
            Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                ? Colors.grey.shade700
                : Colors.white70),
          ],
        ),
      ),
    );
  }
  
  _bankSelect(int index) {
    bankSelected = index;
    informBloc.add('selected');
  }

  _saveInform(BuildContext context) async {
    String amount = controllerAmount.text.trim();
    String note = controllerNote.text.trim();
    if(amount.length < 1) {
      await IfDialog.show(context: context, text: 'ชื่อ-นามสกุล ไม่ถูกต้อง');
    } else {
      try {
        IfDialog().loading(context);
        dynamic response = await Api.call('inform', {
          'type': 'save',
          'amount': amount,
          'note': note,
          'order': '',
        });
        print(response);
        if((response != null) && (response is Map)) {
          if((getString(response['status']) == 'OK') && (response['Inform'] is List)) {
            
          }
        }
      } catch (e) {
        
      }
      Navigator.of(context, rootNavigator: true).pop('dialog');
      Get.back(result: 'success');
    }
  }
  
  _pickImage() async {
    _imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 500,
      maxHeight: 500,
      imageQuality: 80);
    if(_imageFile != null) {
      setState(() {
        _imageName = path.basename(_imageFile.path);
      });
    }
  }

  _pickDate() async {
   DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().day-7),
      lastDate: DateTime.now(),
      initialDate: pickedDate,
    );
    if(date != null) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time
    );
    if(t != null) {
      setState(() {
        time = t;
      });
    }
  }
}

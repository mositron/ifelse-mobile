import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../site.dart';
import '../convert/cart.dart';
import '../convert/util.dart';
import '../convert/api.dart';
import '../convert/dialog.dart';

class InformPage extends StatefulWidget {
  final int edit;
  final String next;
  InformPage({Key key, this.edit, this.next}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return InformPageScreenState(edit, next);
  }
}

class InformPageScreenState extends State<InformPage> {
  int edit = -1;
  String next;
  DateTime pickedDate;
  TimeOfDay time;
  TextEditingController controllerAmount;
  TextEditingController controllerNote;

  InformPageScreenState(this.edit, this.next);

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
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      home: Scaffold(
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
                      Text('จำนวนเงิน', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: controllerAmount,
                        style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font),
                        decoration: InputDecoration(hintText: 'จำนวนเงินที่โอน',),
                        //autofocus: true,
                      ),
                      SizedBox(height: 20),
                      Text('วันที่โอน', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      ListTile(
                        title: Text(pickedDate.year.toString() + '-' + pickedDate.month.toString() + '-' + pickedDate.day.toString()),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: _pickDate,
                      ),
                      SizedBox(height: 20),
                      Text('เวลาที่โอน', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      ListTile(
                        title: Text(time.hour.toString() + ':' + time.minute.toString()),
                        trailing: Icon(Icons.keyboard_arrow_down),
                        onTap: _pickTime,
                      ),
                      SizedBox(height: 20),
                      Text('ที่อยู่ในการจัดส่ง', style: TextStyle(fontSize: Site.fontSize, fontFamily: Site.font, fontWeight: FontWeight.bold)),
                      TextField(
                        controller: controllerNote,
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
                                  _saveInform(context);
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

  
  void _saveInform(BuildContext context) async {
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


  _pickDate() async {
   DateTime date = await showDatePicker(
      context: context,
      firstDate: DateTime(DateTime.now().day-7),
      lastDate: DateTime.now(),
      initialDate: pickedDate,
    );
    if(date != null)
      setState(() {
        pickedDate = date;
      });
  }

  _pickTime() async {
    TimeOfDay t = await showTimePicker(
      context: context,
      initialTime: time
    );
    if(t != null)
      setState(() {
        time = t;
      });
  }
}

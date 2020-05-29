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
    return Container(
      color: Color(0xffe0e0e0),
      child: FutureBuilder<Map<dynamic, dynamic>>(
        future: getOder(),
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

  Future<Map<dynamic, dynamic>> getOder() async {
    dynamic data = await Api.call('order',{'id': id.toString()});

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
                    
                  ],
                )
              ),
              Container(
                alignment: Alignment.centerRight,
                height: 70,
              )
            ],
          ))
        )
      )
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

}

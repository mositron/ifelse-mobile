import 'package:flutter/material.dart';
import '../site.dart';
import 'image.dart';
import 'util.dart';
import 'cache.dart';
import 'toast.dart';

class Cart {
  static List<dynamic> products = [];
  static int amount = 0;
  static double price = 0;
  static double weight = 0;
  static int shipId = 0;
  static double shipPrice = 0; 
  static List<dynamic> address = [];
  static Map<String,dynamic> payment = {};
  static String shipName = '';
  static String shipPhone = '';
  static String shipAddress = '';
  static String shipDetail = '';
  static int payBank = 0;
  static String payType = '';

  static void init() async {
    Cart.products = [];
    dynamic _cart = await cacheGetList('cart');
    if((_cart != null) && (_cart is List) && (_cart.length > 0)) {
      bool save = false;
      _cart.forEach((v){
        if((v['amount'] != null) && (v['amount'] is int)) {
          Cart.products.add(v);
        } else {
          save = true;
        }
      });
      refresh(save);
    }
  }
  
  static void add(Map item) {
    if(item != null) {
      bool found = false;
      for(int i=0; i<products.length; i++) {
        Map product = products[i];
        if((product['id'] == item['id']) && (product['index'] == item['index'])) {
          product['amount'] += item['amount'];
          found = true;
          break;
        }
      }
      if(!found) {
        products.add(item);
      }
      refresh();
    }
  }

  static void refresh([bool save = true]) {
    int _amount = 0;
    if(products.length > 0) {
      for(int i=0; i<products.length; i++) {
        if((products[i] != null) && (products[i] is Map) && (products[i]['amount'] != null) && (products[i]['amount'] is int)) {
          if(products[i]['amount'] > products[i]['stock']) {
            products[i]['amount'] = products[i]['stock'];
          }
          _amount += products[i]['amount'];
        }
      }
    }
    Cart.amount = _amount;
    Cart.price = getPrice();
    Cart.weight = getWeight();
    if(save) {
      cacheSaveList('cart', products);
    }
    Site.cartBloc.add('amount');
  }

  static double getPrice() {
    double sumPrice = 0;
    if((products != null) && (products is List) && (products.length > 0)) {
      products.forEach((v) {
        int _amount = getInt(v['amount']);
        double _price = getDouble(v['price']);
        if((_amount > 0) && (_price > 0)) {
          sumPrice += (_amount * _price);
        }
      });
    }
    return sumPrice;
  }

  static double getWeight() {
    double sumWeight = 0;
    if((products != null) && (products is List) && (products.length > 0)) {
      products.forEach((v) {
        int _amount = getInt(v['amount']);
        double _weight = getDouble(v['weight']);
        if((_amount > 0) && (_weight > 0)) {
          sumWeight += (_amount * _weight);
        }
      });
    }
    return sumWeight;
  }
}

class CartCell extends StatefulWidget {
  final int id;
  final int index;
  final String title;
  final Map image;
  final int amount;
  final double price;
  final String name1;
  final String label1;
  final String name2;
  final String label2;
  final String unit;
  final int stock;
  final Color color;
  final double fsize;
  CartCell({Key key, 
    this.id, this.index, this.title, this.image, this.amount, this.price,
    this.name1, this.label1, this.name2, this.label2, this.unit, this.stock, this.color, this.fsize}) : super(key: key);

  @override
  _CartCellState createState() {
    return new _CartCellState(id, index, title, image, amount, price, name1, label1, name2, label2, unit, stock, color, fsize);
  }
}
 
class _CartCellState extends State<CartCell> {
  int id;
  int index;
  String title;
  Map image;
  int amount;
  double price;
  String name1;
  String label1;
  String name2;
  String label2;
  String unit;
  int stock;
  Color color;
  double fsize;
  _CartCellState(this.id, this.index, this.title, this.image, this.amount, this.price,
    this.name1, this.label1, this.name2, this.label2, this.unit, this.stock, this.color, this.fsize);

  @override
  Widget build(BuildContext context) {
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
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Text(getCurrency(price),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: fsize,color: color)),
          ),
          Container(
            margin: EdgeInsets.only(top:5, bottom:5),
            padding: EdgeInsets.all(0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 30,
                  height: 30,
                  child: RawMaterialButton(
                    onPressed: (){
                      setState(() {
                        amount--;
                        if(amount < 1) {
                          amount = 1;
                          Toast.show('หากต้องการลบ ให้ปัดสินค้ารายการนี้ไปทางด้านซ้ายหรือขวา', context, duration: Toast.lengthShort, gravity:  Toast.bottom);
                        }
                        if(Cart.products.length > 0) {
                          for(int i=0; i<Cart.products.length; i++) {
                            if((Cart.products[i]['id'] == id) && (Cart.products[i]['index'] == index)) {
                              Cart.products[i]['amount'] = amount;
                              break;
                            }
                          }
                        }
                        Cart.refresh();
                      });
                    },
                    elevation: 2,
                    child: Icon(Icons.remove, size: 20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(0.0),
                  width: 50,
                  alignment: Alignment.center,
                  child: Text(amount.toString(), style: TextStyle(fontFamily: Site.font, color: Colors.black))
                ),
                SizedBox(
                  width: 30,
                  height: 30,
                  child: RawMaterialButton(
                    onPressed: () {
                      setState(() {
                        amount++;
                        if(amount > stock) {
                          amount = stock;
                          Toast.show('มีสินค้านี้คงเหลือในคลัง ' + stock.toString() + ' ' + unit, context, duration: Toast.lengthShort, gravity:  Toast.bottom);
                        }
                        if(Cart.products.length > 0) {
                          for(int i=0; i<Cart.products.length; i++) {
                            if((Cart.products[i]['id'] == id) && (Cart.products[i]['index'] == index)) {
                              Cart.products[i]['amount'] = amount;
                              break;
                            }
                          }
                        }
                        Cart.refresh();
                      });
                    },
                    elevation: 2,
                    child: Icon(Icons.add, size: 20),
                  ),
                ),
              ],
            ),
          )
        ]
      )
    );

    return Container(
      margin: EdgeInsets.only(top:5, bottom:5),
      padding: EdgeInsets.only(top:10, left:10, right:10, bottom:3),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: SizedBox(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: 70,
              child: getImageRatio(image, 's', 0)
            ),
            SizedBox(width: 10),
            Expanded(
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
}
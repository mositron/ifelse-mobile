import 'package:flutter/material.dart';
import '../site.dart';
import 'image.dart';
import 'util.dart';


class Cart {
  static List<dynamic> products = [];
  static int amount = 0;
  
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

  static void refresh() {
    int _amount = 0;
    if(products.length > 0) {
      for(int i=0; i<products.length; i++) {
        if(products[i]['amount'] > products[i]['stock']) {
          products[i]['amount'] = products[i]['stock'];
        }
        _amount += products[i]['amount'];
      }
    }
    Cart.amount = _amount;
    Site.cartBloc.add('amount');
  }

  static List<CartCell> getList() {
    if((products != null) && (products is List) && (products.length > 0)) {
      List<CartCell> widget = [];
      products.forEach((v) {
        int _amount = getInt(v['amount']);
        double _price = getDouble(v['price']);
        if((_amount > 0) && (_price > 0)) {
          widget.add(CartCell(
            id: v['id'],
            index: v['index'],
            title: v['title'],
            image: v['image'],
            amount: _amount,
            price: _price,
            name1: v['name1'],
            label1: v['label1'],
            name2: v['name2'],
            label2: v['label2'],
            stock: getInt(v['stock']),
          ));
        }
      });
      return widget;
    }
    return null;
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
  final int stock;
  CartCell({Key key, 
    this.id, this.index, this.title, this.image, this.amount, this.price,
    this.name1, this.label1, this.name2, this.label2, this.stock}) : super(key: key);


  @override
  _CartCellState createState() {
    return new _CartCellState(id, index, title, image, amount, price, name1, label1, name2, label2, stock);
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
  int stock;
  _CartCellState(this.id, this.index, this.title, this.image, this.amount, this.price,
    this.name1, this.label1, this.name2, this.label2, this.stock);

  @override
  Widget build(BuildContext context) {
    //Site.log.e(contentAlign);
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
        children: [
          Expanded(
            child: Text(price.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 16.0,color: Colors.black54)),
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
                    child: Icon(Icons.remove),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(0.0),
                  width: 60,
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
                    child: Icon(Icons.add),
                  ),
                ),
              ],
            ),
          )
        ]
      )
      
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
}
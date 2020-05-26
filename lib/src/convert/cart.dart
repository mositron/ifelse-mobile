import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../site.dart';
import 'api.dart';
import 'align.dart';
import 'image.dart';
import 'gradient.dart';
import 'border.dart';
import 'edge.dart';
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
        if(product['id'] == item['id']) {
          int diff = getInt(item['diff']);
          if(diff == 1) {
            if(product['style1'] == item['style1']) {
              found = true;
            }
          } else if(diff == 2) {
            if((product['style1'] == item['style1']) && (product['style2'] == item['style2'])) {
              found = true;
            }
          } else {
            found = true;
          }

          if(found) {
            product['amount'] = product['amount'] + item['amount'];
            Cart.amount += item['amount'];
            break;
          }
        }
      }
      if(!found) {
        products.add(item);
        Cart.amount += item['amount'];
      }

      print('--------------');
      print(Cart.amount);
      Site.cartBloc.add('amount');
      //print(products);
    } else {
      print('============');
    }
  }

  
  static List<CartCell> getList() {
    if((products != null) && (products is List) && (products.length > 0)) {
      List<CartCell> widget = [];
      products.forEach((v) {
        widget.add(CartCell(
          id: v['id'],
          title: v['title'],
          image: v['image'],
          amount: v['amount'],
          price: v['price'],
        ));
      });
      return widget;
    }
    return null;
  }

}

class CartCell extends StatelessWidget {
  const CartCell({
    this.id, this.title, this.image, this.amount, this.price
  });
  @required
  final int id;
  final String title;
  final Map image;
  final int amount;
  final double price;
  
 
  @override
  Widget build(BuildContext context) {
    //Site.log.e(contentAlign);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 100,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getImageRatio(image, 's', 0),
            SizedBox(width: 10),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, maxLines: 2,  overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontFamily: Site.font, fontSize: Site.fontSize),
                  ),
                  SizedBox(height: 5),
                  Text(
                    '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    price.toString(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
    );
  }
}
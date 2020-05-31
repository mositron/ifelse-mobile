import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../my.dart';
import '../site.dart';
import '../convert/util.dart';
import '../convert/gradient.dart';
import '../convert/icon.dart';
import '../convert/session.dart';
import '../convert/click.dart';
import '../page/login.dart';
import '../page/home.dart';
import '../page/profile.dart';
import '../page/orders.dart';

class GetDrawer extends StatefulWidget {
  final dynamic map;
  final BuildContext context;
  GetDrawer(this.map, this.context);
  
  @override
  State<StatefulWidget> createState() {
    return GetDrawerState(map, context);
  }
}

class GetDrawerState extends State<GetDrawer> {
  bool showUserDetails = false;
  dynamic map;
  BuildContext context;
  GetDrawerState(this.map, this.context);

  @override
  Widget build(BuildContext context) {
    if ((map != null) && !(map is List)) {
      dynamic data = getVal(map,'data'),
        style = getVal(data,'nav.style');
        //data.nav.style
      if(style == 'action') {
        dynamic profile = getVal(data,'drawer.profile');
        Color profileColor = getColor(getVal(profile,'color'));
        Gradient profileBg = getGradient(getVal(profile,'bg'));
        dynamic menu = getVal(data,'drawer.menu');
        Color menuColor = getColor(getVal(menu,'color'));
        Color menuIcon = getColor(getVal(menu,'icon'));
        Gradient menuBg = getGradient(getVal(menu,'bg'));
        return Drawer(
          child: My.id > 0 ?
            _logged(context, profileColor, profileBg, menuIcon, menuColor, menuBg) :
            _login(context, profileColor, profileBg, menuIcon, menuColor, menuBg),
              
        );
      }
    }
    return Container();
  }

  Widget _logged(BuildContext context, Color profileColor, Gradient profileBg, Color menuIcon, Color menuColor, Gradient menuBg) {
    TextStyle _profile = TextStyle(color:profileColor, fontFamily: Site.font);
    TextStyle _menu = TextStyle(color:menuColor, fontFamily: Site.font);
    return Column(
      children: <Widget>[
        Container (
          decoration: BoxDecoration(
            gradient: profileBg,
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(0),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              gradient: profileBg
            ),
            accountName: Text(My.name, style: _profile),
            accountEmail: Text(My.email, style: _profile),
            currentAccountPicture: Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: Image.network(My.image).image,
                  fit: BoxFit.cover,
                ),
              )
            ),
          )
        ),
        ListTile(
          leading: Icon(getIcon('id-card'), color: menuIcon, size: Site.fontSize),
          title: Text('ข้อมูลส่วนตัว', style: _menu),
          onTap: () {
            Navigator.of(context).pop(context);
            Get.to(ProfilePage());
          },
        ),
        ListTile(
          leading: Icon(getIcon('shopping-cart'), color: menuIcon, size: Site.fontSize),
          title: Text('ประวัติการสั่งซื้อ', style: _menu),
          onTap: () {
            Navigator.of(context).pop(context);
            Get.to(OrdersPage());
          },
        ),
        ListTile(
          leading: Icon(getIcon('logout'), color: menuIcon, size: Site.fontSize),
          title: Text('ออกจากระบบ', style: _menu),
          onTap: () {
            sessionDelete();
            Get.offAll(HomePage());
            //Navigator.of(context).pop(context);
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
          },
        ),
        _other(_profile, _menu, menuIcon)
      ]
    );
  }
  Widget _login(BuildContext context, Color profileColor, Gradient profileBg, Color menuIcon, Color menuColor, Gradient menuBg) {
    TextStyle _profile = TextStyle(color:profileColor, fontFamily: Site.font);
    TextStyle _menu = TextStyle(color:menuColor, fontFamily: Site.font, fontSize: Site.fontSize);
    return ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        Container (
          height: 80,
          decoration: BoxDecoration(
            gradient: profileBg
          ),
          padding: EdgeInsets.all(0),
          margin: EdgeInsets.all(0),
          child: DrawerHeader(
            child: Container(
              width: double.infinity,
              height: 80,
            ),
          )
        ),
        ListTile(
          leading: Icon(getIcon('sign-in'), color: menuIcon, size: Site.fontSize),
          title: Text('ล็อคอิน / สมัครสมาชิก', style: _menu),
          onTap: () {
            //Get.to(LoginPage());
            Navigator.of(context).pop(context);
            Get.to(LoginPage());
            //Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
          },
        ),
        _other(_profile, _menu, menuIcon)
      ]
    );
  }

  Widget  _other(TextStyle _profile, TextStyle _menu, Color menuIcon) {
    return Column(
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 0.5,
          margin: EdgeInsets.symmetric(vertical: 4),
          color: Colors.grey.shade300,
        ),
        ListTile(
          leading: Icon(getIcon('web'), color: menuIcon, size: Site.fontSize),
          title: Text('ไปยังเว็บไซต์', style: _menu),
          onTap: () {
            getClicked(context, {'type':'link', 'link': 'https://'+Site.domain});
          }
        )
      ]
    );
  }
}

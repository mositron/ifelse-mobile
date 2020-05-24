import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../my.dart';
import '../site.dart';
import '../convert/util.dart';
import '../convert/gradient.dart';
import '../convert/icon.dart';
import '../convert/image.dart';
import '../convert/session.dart';
import '../page/login.dart';
import '../page/home.dart';
import '../page/profile.dart';

class GetDrawer extends StatefulWidget {
  final dynamic map;
  final BuildContext context;
  GetDrawer(this.map, this.context);
  @override
  _Drawer createState() => _Drawer(map, context);
}

class _Drawer extends State<GetDrawer> {
  bool showUserDetails = false;
  dynamic map;
  BuildContext context;

  _Drawer(this.map, this.context);

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
              _login(context, profileColor, profileBg, menuIcon, menuColor, menuBg)
        );
      }
    }
    return null;
  }
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
        leading: Icon(getIcon('logout'), color: menuIcon, size: Site.fontSize),
        title: Text('ออกจากระบบ', style: _menu),
        onTap: () {
          sessionDelete();
          Get.offAll(HomePage());
          //Navigator.of(context).pop(context);
          //Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomePage()));
        },
      )
    ]
  );
}
Widget _login(BuildContext context, Color profileColor, Gradient profileBg, Color menuIcon, Color menuColor, Gradient menuBg) {
  TextStyle _profile = TextStyle(color:profileColor, fontFamily: Site.font);
  TextStyle _menu = TextStyle(color:menuColor, fontFamily: Site.font);
  return ListView(
    padding: EdgeInsets.zero,
    children: <Widget>[
      Container (
        height: 150,
        decoration: BoxDecoration(
          gradient: profileBg
        ),
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(0),
        child: DrawerHeader(
          child: Container(
            width: double.infinity,
            height: 100,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('- ยังไม่ได้ล็อคอิน -', style: _profile)
              ],
            )
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
      )
    ]
  );
}

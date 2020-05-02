import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'const.dart';


class MyPage extends StatelessWidget {
  MyPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.navName, home: MyPagefulWidget(),
    );
  }
}

class MyPagefulWidget extends StatefulWidget {
  MyPagefulWidget({Key key}) : super(key: key);
  @override
  _MyPagefulWidgetState createState() => _MyPagefulWidgetState();
}


class _MyPagefulWidgetState extends State<MyPagefulWidget> with SingleTickerProviderStateMixin {

  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: Site.pageTab.length, vsync: this);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  GradientAppBar getAppBarGradient() {
    Widget title;
    if(Site.navType == 'image' && Site.navImage.isNotEmpty) {
      title = Image.network(Site.navImage, fit: BoxFit.cover);
    } else {
      title = Text(Site.navName, style: TextStyle(color: Site.navTxt, fontFamily: "Kanit"));
    }
    AlignmentGeometry begin = Alignment.centerLeft;
    AlignmentGeometry end = Alignment.centerRight;
    if(Site.navRange == 2) {
      begin = Alignment.topCenter;
      end = Alignment.bottomCenter;
    } else if(Site.navRange == 3) {
      begin = Alignment.topLeft;
      end = Alignment.bottomRight;
    } else if(Site.navRange == 4) {
      begin = Alignment.bottomLeft;
      end = Alignment.topRight;
    }
    LinearGradient bg = LinearGradient(colors: [Site.navBg1, Site.navBg2], begin: begin, end: end);
    return GradientAppBar(
      title: title,
      elevation: Site.navShadow == 1 ? 8 : 0,
      centerTitle: Site.navPos == 1,
      gradient: bg,
      bottom: (Site.menuType == 'bottom') ? null : getTabBar(),
    );
  }
  
  AppBar getAppBar() {
    Widget title;
    if(Site.navType == 'image' && Site.navImage.isNotEmpty) {
      title = Image.network(Site.navImage, fit: BoxFit.cover);
    } else {
      title = Text(Site.navName, style: TextStyle(color: Site.navTxt, fontFamily: "Kanit"));
    }
    return AppBar(
      title: title,
      elevation: Site.navShadow == 1 ? 8 : 0,
      centerTitle: Site.navPos == 1,
      backgroundColor: Site.navBg == 1 ? Site.navBg1 : Colors.transparent,
      bottom: (Site.menuType == 'bottom') ? null : getTabBar(),
    );
  }

  TabBar getTabBar() {
    return TabBar(
      indicatorWeight: 0.1,
      labelPadding: EdgeInsets.all(0),
      labelColor: Site.menuFocus,
      labelStyle: TextStyle(fontSize: 14.0, fontFamily: "Kanit"),
      unselectedLabelColor: Site.menuTxt,
      unselectedLabelStyle: TextStyle(fontSize: 14.0, fontFamily: "Kanit"),
      tabs: Site.pageTab,
      controller: controller,
    );
  }

  @override
  Widget build(BuildContext context) {    
    BoxDecoration box;   
    if(Site.appBg == 2) {
      AlignmentGeometry begin = Alignment.centerLeft;
      AlignmentGeometry end = Alignment.centerRight;
      if(Site.appRange == 2) {
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
      } else if(Site.appRange == 3) {
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
      } else if(Site.appRange == 4) {
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
      }
      box = BoxDecoration(
        gradient: LinearGradient(colors: [Site.appBg1, Site.appBg2], begin: begin, end: end)
      );
    } else {
      box = BoxDecoration(
        color: Site.appBg1
      );
    }

    BoxDecoration menu;   
    if(Site.menuBg == 2) {
      AlignmentGeometry begin = Alignment.centerLeft;
      AlignmentGeometry end = Alignment.centerRight;
      if(Site.menuRange == 2) {
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
      } else if(Site.menuRange == 3) {
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
      } else if(Site.menuRange == 4) {
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
      }
      menu = BoxDecoration(
        gradient: LinearGradient(colors: [Site.menuBg1, Site.menuBg2], begin: begin, end: end)
      );
    } else if(Site.menuBg == 1) {
      menu = BoxDecoration(
        color: Site.menuBg1
      );
    }
    BorderRadius radius = BorderRadius.only(
          topLeft: Radius.circular(Site.bodyRD1),
          topRight: Radius.circular(Site.bodyRD2),
          bottomLeft: Radius.circular(Site.bodyRD3),
          bottomRight: Radius.circular(Site.bodyRD4)
    );

    BoxDecoration body;   
    if(Site.bodyBg == 2) {
      AlignmentGeometry begin = Alignment.centerLeft;
      AlignmentGeometry end = Alignment.centerRight;
      if(Site.bodyRange == 2) {
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
      } else if(Site.bodyRange == 3) {
        begin = Alignment.topLeft;
        end = Alignment.bottomRight;
      } else if(Site.bodyRange == 4) {
        begin = Alignment.bottomLeft;
        end = Alignment.topRight;
      }
      body = BoxDecoration(
        gradient: LinearGradient(colors: [Site.bodyBg1, Site.bodyBg2], begin: begin, end: end),
        borderRadius: radius,
      );
    } else if(Site.bodyBg == 1) {
      body = BoxDecoration(
        color: Site.bodyBg1,
        borderRadius: radius,
      );
    }
    

    return Container(
      decoration: box,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: Site.navBg == 2 ? getAppBarGradient() : getAppBar(),
        body: Container(
          decoration: body,
          margin: EdgeInsets.only(top:Site.bodyMTop, bottom:Site.bodyMBottom, left:Site.bodyMLeft, right:Site.bodyMRight),
          padding: EdgeInsets.only(top:Site.bodyPTop, bottom:Site.bodyPBottom, left:Site.bodyPLeft, right:Site.bodyPRight),
          child: TabBarView(
            children: Site.pageType,
            controller: controller,
          ),
        ),
        bottomNavigationBar: (Site.menuType == 'bottom') ? Material(
          color: Colors.transparent,
          child: Container(
            decoration: menu,
            child: getTabBar()
          ),
        ) : null,
      )
    );
  }
}
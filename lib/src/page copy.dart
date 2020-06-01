import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'site.dart';
import 'body.dart';
import 'layer/appbar.dart';
import 'layer/navbar.dart';
import 'layer/topbar.dart';
import 'layer/cartbar.dart';
import 'layer/drawer.dart';
import 'convert/align.dart';
import 'convert/gradient.dart';
import 'convert/util.dart';

class PageWidget extends StatefulWidget {
  final String file;
  final Map<String, dynamic> par;
  final Function func;
  final BuildContext buildContext;
  PageWidget({Key key, this.buildContext, this.file, this.par, this.func}) : super(key: key);

  @override
  _PageWidgetState createState() => _PageWidgetState(buildContext, file, par, func);
}

class _PageWidgetState extends State<PageWidget> with TickerProviderStateMixin {
  String file;
  Map<String,dynamic> par = {};
  Function func;
  int _selectedIndex = 0;
  AppBar _appbar;
  Widget _navbar;
  bool _isBottomBar = true;
  Widget _drawer;
  int _showNavbar;
  int _showAppbar;
  TabController _tabController;
  List<Map<String,dynamic>> _items = [];
  Map<String,dynamic> template = {};
  dynamic _box;
  double _offsetTop = 0;
  double _offsetBottom = 0;
  List<Widget> _pages = <Widget>[];
  BuildContext buildContext;
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();

  _PageWidgetState(this.buildContext, this.file, this.par, this.func);

  @override
  void initState() {
    super.initState();
    _pages = [];
    _items = [];
    _selectedIndex = 0;
    
    if(Site.template[file] is List) {
      dynamic json = Site.template[file];
      // เทมเพลทที่มีได้หลายแบบ ให้ใช้แบบแรกไปก่อน
      if(['article','articles','products','product'].contains(file)) {
        json = json[0];
      }
      if ((json is List) && (json[0] is Map) && (json[0]['type'] == 'content')) {
        template = json[0];
        _box = getVal(template,'box');
        dynamic data = getVal(template,'data');
        _showAppbar = getInt(getVal(data,'appbar'));
        _showNavbar = getInt(getVal(data,'navbar'));

        if(_showNavbar > 0) {
          if(file == 'home') {
            _showNavbar = 3;
          }
          dynamic items = getVal(template,'child.navbar.data.items');
          if((items != null) && (items is List)) {
            for(int i=0; i<items.length; i++) {
              Map v = items[i];
              v['type'] = v['type'].toString();
              if(v['type'] == 'home') {
                _selectedIndex = i;
              }
              _items.add(v);
              _pages.add(null);
            }

            if((_items.length > 1) && (_showNavbar == 3)) {
              _isBottomBar = false;
              _tabController = TabController(length: _items.length, vsync: this);
            }
          }
        }
        if(_pages.length == 0) {
          _pages.add(null);
        }
      }
    }
  }
  
  @override
  void dispose() {
    if(_tabController != null) {
      _tabController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(Site.template[file] is List) {
      dynamic json = Site.template[file];
      // เทมเพลทที่มีได้หลายแบบ ให้ใช้แบบแรกไปก่อน
      if(['article','articles','products','product'].contains(file)) {
        json = json[0];
      }
      if ((json is List) && (json[0] is Map) && (json[0]['type'] == 'content')) {
        template = json[0];
        dynamic child = getVal(template,'child');
        dynamic data = getVal(template,'data');
        // จัดการ AppBar
        if(_showAppbar > 0) {
            _appbar = getAppBar(context, getVal(child,'appbar'), appClick);
          if((_showAppbar == 2) && (_appbar != null)) {
            _offsetTop = MediaQuery.of(context).padding.top + _appbar.preferredSize.height;
          }
        }
        // จัดการ NavBar
        if(_showNavbar > 0) {
          if(file == 'home') {
            if(_showNavbar == 3) {
              _navbar = TopBar(controller: _tabController, map: getVal(child,'navbar'), func: navClick);
            } else {
              _navbar = NavBar(map: getVal(child,'navbar'), func: navClick);
            }
          } else if(file == 'cart') {
            _navbar = CartBar(map: getVal(child,'navbar'), func: navClick);
          }
          if((_showNavbar == 2) && (_navbar != null)) {
            _offsetBottom = getDouble(getVal(data,'bottom'));
          }
        }
        // จัดการ Drawer
        _drawer = (_showAppbar > 0 ? GetDrawer(getVal(child,'appbar'), context) : null);
        //data.nav.style
        getPage(true);
        
        return Container(        
          decoration: BoxDecoration(
            gradient: getGradient(getVal(_box,'bg.color')),
          ),
          child: Scaffold(
            key: _drawerKey,
            extendBody: _showNavbar == 2,
            extendBodyBehindAppBar: _showAppbar == 2,
            backgroundColor: Colors.transparent,
            appBar: _appbar,
            body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints viewportConstraints) {
                if((_showNavbar == 3) && (_navbar != null)) {
                  print(_navbar);
                  return Stack(
                    key: UniqueKey(),
                    children: <Widget>[
                      _navbar,
                      TabBarView(
                        controller: _tabController,
                        children: _pages,
                      )
                      /*
                      SingleChildScrollView(
                        child: Center(
                          child: Container(
                            padding: EdgeInsets.only(top:_offsetTop, bottom:_offsetBottom),
                            alignment: getAlignScreen(getVal(data,'align')),                 
                            child: _pages[_selectedIndex],
                          ),
                        )
                      )
                      */
                    ],
                  );
                } else {

                  return SingleChildScrollView(
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: viewportConstraints.maxHeight,
                        ),
                        padding: EdgeInsets.only(top:_offsetTop, bottom:_offsetBottom),
                        alignment: getAlignScreen(getVal(data,'align')),                 
                        child: _pages[_selectedIndex],
                      ),
                    )
                  );
                }
              }
            ),
            drawer: _drawer,
            bottomNavigationBar: _isBottomBar ? _navbar : null,
            resizeToAvoidBottomInset: true,
          )
        );
      }
    }
    return Center(
      child: Container(
        color: getColor('f5f5f5'),
        alignment: Alignment.center,
        child: Text('ยังไม่ได้สร้างเทมเพลทสำหรับหน้า 1 - '+file, 
          textAlign: TextAlign.center,
          style: TextStyle(color: getColor('c00'),fontFamily: Site.font, fontSize: 24),
        )
      )    
    );
  }

  void appClick() {
    if(file == 'home') {
      _drawerKey.currentState.openDrawer();
    } else {
      Get.back();
    }
  }

  void navClick(int index) {
    setState(() {
      _selectedIndex = index;
      getPage(false);
    });
  }

  void getPage(bool current) {
    if(_pages[_selectedIndex] == null) {      
      if(_items.length > _selectedIndex) {
        dynamic item = _items[_selectedIndex];
        _pages[_selectedIndex] = BodyWidget(key: UniqueKey(), file:item['type'], par: current ? par : item, func: func);
      } else {
        _pages[_selectedIndex] = BodyWidget(key: UniqueKey(), file:file, par: par, func: func);
      }
    }
  }
}
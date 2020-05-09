import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: HomePageWidget());
  }
}

class HomePageWidget extends StatefulWidget {
  HomePageWidget({Key key}) : super(key: key);
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> with SingleTickerProviderStateMixin {
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
  @override
  Widget build(BuildContext context) {    
    return Layer.buildContent(Site.template['home'],context);
  }
}
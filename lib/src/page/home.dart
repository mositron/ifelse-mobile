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

class _HomePageWidgetState extends State<HomePageWidget> {
  TabController controller;
  Widget render;
  @override
  void initState() {
    super.initState();
    render = null;
  }
  @override
  void dispose() {
    render = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(render == null) {
      render = Layer.buildContent('home',context);
    }
    return render;
  }
}
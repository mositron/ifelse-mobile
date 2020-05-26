import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../site.dart';
import '../layer.dart';
import '../bloc/cart.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: HomePageWidget(), debugShowCheckedModeBanner:false);
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
    render = null;
    super.initState();
  }
  @override
  void dispose() {
    render = null;
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    if(Site.cartBloc == null) {
      Site.cartBloc = CartBloc();
    }
    if(render == null) {
      render = BlocProvider<CartBloc>(
        create: (context) => Site.cartBloc,
        child: Layer.buildContent('home',context)
      );
    }
    return render;
  }
}
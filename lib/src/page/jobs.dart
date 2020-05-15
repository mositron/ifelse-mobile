import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class JobsPage extends StatelessWidget {
  JobsPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: JobsPageWidget(par: par));
  }
}

class JobsPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  JobsPageWidget({Key key, this.par}) : super(key: key);
  @override
  _JobsPageWidgetState createState() => _JobsPageWidgetState(par);
}

class _JobsPageWidgetState extends State<JobsPageWidget> with SingleTickerProviderStateMixin {
  bool loaded;
  TabController controller;
  Map<String, dynamic> par;

  _JobsPageWidgetState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> request = {
      'order': '',
      'skip': '0'
    };
    request['text'] = 'ตำแหน่งงาน';
    return Layer.buildContent('jobs',context, request);
  }
}
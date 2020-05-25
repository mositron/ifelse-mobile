import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';

class JobsPage extends StatelessWidget {
  JobsPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: JobsPageWidget(buildContext: context, par: par), debugShowCheckedModeBanner:false);
  }
}

class JobsPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  final BuildContext buildContext;
  JobsPageWidget({Key key, this.buildContext, this.par}) : super(key: key);
  @override
  _JobsPageWidgetState createState() => _JobsPageWidgetState(buildContext, par);
}

class _JobsPageWidgetState extends State<JobsPageWidget> {
  bool loaded;
  BuildContext buildContext;
  Map<String, dynamic> par;

  _JobsPageWidgetState(this.buildContext, this.par);
  
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
    return Layer.buildContent('jobs', buildContext, request);
  }
}
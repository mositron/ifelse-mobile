import 'package:flutter/material.dart';
import '../site.dart';
import '../layer.dart';
import '../convert/job.dart';
import '../convert/dialog.dart';
import '../convert/util.dart';

class JobPage extends StatelessWidget {
  JobPage({Key key, this.par}) : super(key: key);
  final Map<String, dynamic> par;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: Site.name, home: JobPageWidget(par: par));
  }
}

class JobPageWidget extends StatefulWidget {
  final Map<String, dynamic> par;
  JobPageWidget({Key key, this.par}) : super(key: key);
  @override
  _JobPageWidgetState createState() => _JobPageWidgetState(par);
}

class _JobPageWidgetState extends State<JobPageWidget> with SingleTickerProviderStateMixin {
  bool loaded;
  TabController controller;
  Map<String, dynamic> par;

  _JobPageWidgetState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    //Site.log.e('get job - ' + getVal(par, '_id').toString());
    int id = getInt(getVal(par, '_id'));
    if(id > 0) {
      return Container(
        color: Colors.transparent,
        child: FutureBuilder<Map>(
          future: Job.getJob(id),
          builder: (context, snapshot) {
            return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                    ? getWidget(snapshot.data)
                    : Job.retryButton(fetch)
                : IfDialog.getLoading();
          }
        )
      );
    } else {
      //throw Exception("Invalid ID.\nPlease Retry");
      return Container();
    }
  }

  setLoading(bool loading) {
    setState(() {
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }

  Widget getWidget(dynamic data) {
    if(data is Map) {
      return Layer.buildContent('job',context, data);
    }
    return Container();
  }
}
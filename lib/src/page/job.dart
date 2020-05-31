import 'package:flutter/material.dart';
import '../layer.dart';
import '../site.dart';
import '../convert/job.dart';
import '../convert/dialog.dart';
import '../convert/util.dart';

class JobPage extends StatefulWidget {
  final Map<String, dynamic> par;
  JobPage({Key key, this.par}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return JobState(par);
  }
}

class JobState extends State<JobPage> {
  bool loaded;
  Map<String, dynamic> par;
  JobState(this.par);
  
  @override
  void initState() {
    super.initState();
    loaded = false;
  }

  @override
  Widget build(BuildContext context) {
    int id = getInt(getVal(par, '_id'));
    return MaterialApp(
      title: Site.name, 
      debugShowCheckedModeBanner:false,
      color: Colors.white,
      builder: (context, child) {    
        if(id > 0) {
          return FutureBuilder<Map>(
            future: Job.getJob(id),
            builder: (context, snapshot) {
              return snapshot.connectionState == ConnectionState.done
                ? snapshot.hasData
                  ? getWidget(context, snapshot.data)
                  : Job.retryButton(fetch)
                : IfDialog.getLoading();
            }
          );
        } else {
          return Container();
        }
      }
    );
  }

  setLoading(bool loading) {
    setState(() {
      loaded = loading;
    });
  }
 
  fetch() {
    setLoading(true);
  }

  Widget getWidget(BuildContext context, dynamic data) {
    if(data is Map) {
      return Layer.buildContent('job', context, data);
    }
    return Container();
  }
}
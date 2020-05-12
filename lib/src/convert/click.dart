import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';




void getClicked(BuildContext context,Map click) {
  if(click != null) {
    switch (click['type'].toString()) {
      case 'link':
        _launchURL(click['link'] ?? 'https://ifelse.co');
        break;
      case 'articles':
      case 'products':
      case 'jobs':
      case 'article':
      case 'product':
      case 'job':
    }
  }
}


void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

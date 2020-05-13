import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import '../page/articles.dart';

void getClicked(BuildContext context,Map click) {
  if(click != null) {
    switch (click['type'].toString()) {
      case 'link':
        _launchLink(click['link'] ?? 'https://ifelse.co');
        break;
      case 'articles':
        _launchArticles(context, click);
        break;
      case 'products':
      case 'jobs':
      case 'article':
      case 'product':
      case 'job':
    }
  }
}

void _launchLink(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

void _launchArticles(BuildContext context, Map click) {
  Map<String, dynamic> request = {'category':click['articles']};
  Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlesPage(par:request)));
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../page/articles.dart';
import '../page/products.dart';
import '../page/jobs.dart';

void getClicked(BuildContext context,dynamic click) {
  if(click != null && click is Map) {
    switch (click['type'].toString()) {
      case 'link':
        _launchLink(click['link'] ?? 'https://ifelse.co');
        break;
      case 'articles':
        _launchArticles(context, click);
        break;
      case 'products':
        _launchProducts(context, click);
        break;
      case 'jobs':
        _launchJobs(context, click);
        break;
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
  Get.to(ArticlesPage(par:request));
  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ArticlesPage(par:request)));
}

void _launchProducts(BuildContext context, Map click) {
  Map<String, dynamic> request = {'category':click['products']};
  Get.to(ProductsPage(par:request));
  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductsPage(par:request)));
}

void _launchJobs(BuildContext context, Map click) {
  Map<String, dynamic> request = {'category':click['jobs']};
  Get.to(JobsPage(par:request));
  //Navigator.of(context).push(MaterialPageRoute(builder: (context) => JobsPage(par:request)));
}
